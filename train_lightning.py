# set up environment
import argparse
import datetime
import logging
import os
import random
import tempfile
from contextlib import nullcontext
from pathlib import Path

import lightning as L
import matplotlib.pyplot as plt
import monai.data
import monai.transforms
import monai.utils.misc
import numpy as np
import torch
import torch.distributed as dist
import torch.multiprocessing as mp
import torch.nn.functional as F
import torchio as tio
import wandb
from lightning.pytorch.callbacks import ModelCheckpoint
from lightning.pytorch.loggers import WandbLogger
from lightning.pytorch.strategies import DDPStrategy
from monai.data import DataLoader
from monai.losses import DiceCELoss
from segment_anything import BaseTrainer
from segment_anything.build_sam3D import sam_model_registry3D
from torch.backends import cudnn
from torch.cuda import amp
from torch.nn.parallel import DistributedDataParallel as DDP
from torch.utils.data.distributed import DistributedSampler
from tqdm import tqdm
from utils import training as TRAINING
from utils import validation as VALIDATION
from utils.click_method import get_next_click3D_torch_2
from utils.data_loader import BackgroundDataLoader, DatasetMerged

join = os.path.join

# %% set up parser
parser = argparse.ArgumentParser()
parser.add_argument("--task_name", type=str, default="union_train")
parser.add_argument("--click_type", type=str, default="random")
parser.add_argument("--multi_click", action="store_true", default=False)
parser.add_argument("--num_clicks", type=int, default=11)
parser.add_argument("--largest_first", action="store_true", default=False)
parser.add_argument("--bbox_first", action="store_true", default=False)
parser.add_argument("--model_type", type=str, default="vit_b_ori")
parser.add_argument("--checkpoint", type=str)
parser.add_argument("--device", type=str, default="auto")
parser.add_argument("--work_dir", type=str, default="./work_dir")

# train
parser.add_argument("--num_workers", type=int, default=24)
parser.add_argument("--gpu_ids", type=int, nargs="+", default=None)
parser.add_argument("--resume", action="store_true", default=False)
parser.add_argument("--precision", type=str, default="bf16-mixed")

# lr_scheduler
parser.add_argument("--lr_scheduler", type=str, default="multisteplr")
parser.add_argument("--step_size", type=int, nargs="+", default=[120, 180])
parser.add_argument("--gamma", type=float, default=0.1)
parser.add_argument("--num_epochs", type=int, default=200)
parser.add_argument("--img_size", type=int, default=112)
parser.add_argument("--volume_threshold", type=int, default=10)
parser.add_argument("--batch_size", type=int, default=10)
parser.add_argument("--accumulation_steps", type=int, default=20)
parser.add_argument("--lr", type=float, default=8e-4)
parser.add_argument("--weight_decay", type=float, default=0.1)

args = parser.parse_args()

torch.set_float32_matmul_precision("medium")

def build_model(args):
    sam_model = sam_model_registry3D[args.model_type](checkpoint=None, image_size=args.img_size)
    return sam_model


def get_dataloaders(args):

    dataset = DatasetMerged(
        # paths=TRAINING, # TODO: change
        paths=Path("data_fixed/medical_preprocessed/overall_Tr.json"),
        image_size=args.img_size,
        threshold=args.volume_threshold,
    )
    train_transforms = monai.transforms.Compose(
        [
            monai.transforms.LoadImaged(keys=["image", "label"], ensure_channel_first=True),
            monai.transforms.Orientationd(keys=["image", "label"], axcodes="RAS"),
            monai.transforms.ScaleIntensityRangePercentilesd(
                keys=["image"],
                lower=0.05,
                upper=99.95,
                b_min=-1,
                b_max=1,
                clip=True
            ),
            monai.transforms.CropForegroundd( # TODO: do we need?
                keys=["image", "label"],
                source_key="image",
                select_fn=lambda x: x > -1,

            ),
            # monai.transforms.OneOf([
            #     monai.transforms.RandAffined(
            #         keys=["image", "label"],
            #         prob=0.6,
            #         shear_range=(0.1, 0.1, 0.1),
            #         mode=("bilinear", "nearest"),
            #         padding_mode="constant",
            #     ),
            #     monai.transforms.RandZoomd(
            #         keys=["image", "label"],
            #         prob=0.6,
            #         min_zoom=0.75,
            #         max_zoom=1.5,
            #         mode=("bilinear", "nearest"),
            #         padding_mode="constant",
            #     ),
            # ]),
            monai.transforms.Compose([
                monai.transforms.RandFlipd(keys=["image", "label"], prob=0.3, spatial_axis=0),
                monai.transforms.RandFlipd(keys=["image", "label"], prob=0.3, spatial_axis=1),
                monai.transforms.RandFlipd(keys=["image", "label"], prob=0.3, spatial_axis=2),
                monai.transforms.RandRotate90d(keys=["image", "label"], prob=0.3, spatial_axes=(0, 1)),
                monai.transforms.RandRotate90d(keys=["image", "label"], prob=0.3, spatial_axes=(1, 2)),
                monai.transforms.RandRotate90d(keys=["image", "label"], prob=0.3, spatial_axes=(0, 2)),
            ]),
            monai.transforms.ToTensord(keys=["image", "label"]),
            # monai.transforms.OneOf([
            #     monai.transforms.RandAdjustContrastd(keys=["image"], prob=0.5, gamma=(0.5, 2.0)),
            #     monai.transforms.RandGaussianNoised(keys=["image"], prob=0.5),
            #     monai.transforms.RandGaussianSmoothd(keys=["image"], prob=0.5),
            #     monai.transforms.RandHistogramShiftd(keys=["image"], prob=0.5, num_control_points=10),
            #     monai.transforms.RandGaussianSharpend(keys=["image"], prob=0.5),
            # ]),
            # monai.transforms.RandCropByLabelClassesd(
            #     keys=["image", "label"],
            #     label_key="label",
            #     spatial_size=[args.img_size, args.img_size, args.img_size],
            #     ratios=[0, 1],
            #     num_samples=1,
            #     num_classes=2,
            #     allow_smaller=True,
            # ),
            monai.transforms.RandCropByPosNegLabeld(
                keys=["image", "label"],
                label_key="label",
                spatial_size=[args.img_size, args.img_size, args.img_size],
                pos=1,
                neg=0,
                num_samples=1,
                allow_smaller=True,
            ),
            # ensure that we have the right shape in the end
            monai.transforms.ResizeWithPadOrCropd(
                keys=["image", "label"],
                spatial_size=[args.img_size, args.img_size, args.img_size],
            ),
            monai.transforms.EnsureTyped(keys=["image", "label"]),
        ]
    )
    all_data=dataset.get_filtered_json()
    print(f"All data len {len(all_data)}")
    cache_dir = Path(tempfile.mkdtemp()) / "persistent_cache"
    # train_dataset = monai.data.PersistentDataset( # TODO: make persistent
    train_dataset = monai.data.Dataset(
        data=all_data,
        transform=train_transforms,
        # cache_dir=cache_dir,
    )

    # train_dataset = monai.data.CacheDataset(
    #     data=all_data,
    #     transform=train_transforms,
    #     cache_rate=1.0,
    #     num_workers=args.num_workers,
    # )

    train_dataloader = BackgroundDataLoader(
        dataset=train_dataset,
        batch_size=args.batch_size,
        shuffle=True,
        num_workers=args.num_workers,
        pin_memory=True,
    )
    # check_data = monai.utils.misc.first(train_dataloader)
    # print(check_data["image"].shape, check_data["label"].shape)

    # import pdb; pdb.set_trace()

    return train_dataloader

def init_seeds(seed=0):
    L.seed_everything(seed, workers=True)


def main():
    # build model
    model = build_model(args)
    
    # Load datasets
    dataloaders = get_dataloaders(args)
    

    if args.checkpoint and not args.resume:
        lightning_module = BaseTrainer.load_from_checkpoint(args.checkpoint)
    else:
        lightning_module = BaseTrainer(model, args)

    callbacks =[
        ModelCheckpoint(
            dirpath=Path(args.work_dir) / args.task_name,
            monitor="train_loss",
            verbose=True,
            filename="best-loss-{epoch}-{train_loss:.4f}",
        ),
        ModelCheckpoint(
            dirpath=Path(args.work_dir) / args.task_name,
            monitor="train_dice",
            verbose=True,
            filename="best-dice-{epoch}-{train_dice:.4f}",
            mode="max",
        )
    ]

    lightning_loggers = [
        WandbLogger(
            name=args.task_name,
            project="Neuro-SAM-3D",
            config=args,
            log_model="all",
        )
    ]
    # lightning_loggers[0].watch(lightning_module, log="all")

    strategy = DDPStrategy()

    trainer = L.Trainer(
        default_root_dir=Path(args.work_dir) / args.task_name,
        accelerator=args.device,
        devices=args.gpu_ids if isinstance(args.gpu_ids, list) else "auto", # TODO: change when running on cluster
        accumulate_grad_batches=args.accumulation_steps,
        check_val_every_n_epoch=1,
        callbacks=callbacks,
        max_epochs=args.num_epochs,
        precision=args.precision, # TODO: make sure works w HPC
        num_nodes=1, # TODO: change for HPC
        gradient_clip_val=None,
        logger=lightning_loggers,
        benchmark=True,
        enable_progress_bar=True,
        use_distributed_sampler=True,
        strategy="ddp_find_unused_parameters_true", # TODO: change
        log_every_n_steps=1,
    )
    
    # Train
    trainer.fit(
        model=lightning_module,
        train_dataloaders=dataloaders,
        val_dataloaders=None,
        ckpt_path=args.checkpoint if args.resume else None
    )


# def main
if __name__ == "__main__":
    main()