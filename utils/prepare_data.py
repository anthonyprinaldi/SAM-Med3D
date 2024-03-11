import json
import os
import os.path as osp
import shutil

import nibabel as nib
import torchio as tio
from prepare_json_data import *
from tqdm import tqdm

DATASET_ROOT = "../data"
DATASET_LIST = [
    AbdomenCTJSONGenerator,
    AMOSJSONGenerator,
    BratsJSONGenerator,
    CovidCTJSONGenerator,
    CTStrokeJSONGenerator,
    HealthyTotalBodyJSONGenerator,
    ISLESJSONGenerator,
    KitsJSONGenerator,
    KneeJSONGenerator,
    LITSJSONGenerator,
    LUNAJSONGenerator,
    MMWHSJSONGenerator,
    MSDJSONGenerator,
    CTORGJSONGenerator,
    UpennJSONGenerator,
    ProstateJSONGenerator,
    SegTHORJSONGenerator,
    TCIAPancreasJSONGenerator,
    TotalSegmentatorJSONGenerator,
    ONDRIJSONGenerator,
    WORDJSONGenerator
]
TARGET_DIR = "./data/medical_preprocessed"

def resample_nii(input_path: str, output_path: str, target_spacing: tuple = (1.5, 1.5, 1.5), n=None, reference_image=None, mode="linear"):
    """
    Resample a nii.gz file to a specified spacing using torchio.

    Parameters:
    - input_path: Path to the input .nii.gz file.
    - output_path: Path to save the resampled .nii.gz file.
    - target_spacing: Desired spacing for resampling. Default is (1.5, 1.5, 1.5).
    """
    
    # Load the nii.gz file using torchio
    subject = tio.Subject(
        img=tio.ScalarImage(input_path)
    )
    resampler = tio.Resample(target=target_spacing, image_interpolation=mode)
    resampled_subject = resampler(subject)
    
    if(n is not None):
        image = resampled_subject.img
        tensor_data = image.data
        if(isinstance(n, int)):
            n = [n]
        for ni in n:
            tensor_data[tensor_data == ni] = -1
        tensor_data[tensor_data != -1] = 0
        tensor_data[tensor_data != 0] = 1
        save_image = tio.ScalarImage(tensor=tensor_data, affine=image.affine)
        reference_size = reference_image.shape[1:]  # omitting the channel dimension
        cropper_or_padder = tio.CropOrPad(reference_size)
        save_image = cropper_or_padder(save_image)
    else:
        save_image = resampled_subject.img
    
    save_image.save(output_path)


def main():
    for dataset in DATASET_LIST:
        dataset_dir = dataset.dir
        meta_info = json.load(open(osp.join(dataset_dir, "dataset.json")))

        print(meta_info['name'], meta_info['modality'])
        num_classes = len(meta_info["labels"])-1
        print("num_classes:", num_classes, meta_info["labels"])
        # resample_img_dir = osp.join(dataset_dir, "imagesTr_1.5")
        # print(f"{resample_img_dir=}")

        # os.makedirs(resample_img_dir, exist_ok=True)
        # for idx, cls_name in meta_info["labels"].items():
        dataset_name = dataset.name
        for item in tqdm(meta_info["training"], desc=f"{dataset_name}"):
            
            img, seg, seg_idx = item["image"], item["seg"], int(item["seg_index"])
            
            cls_name = meta_info["labels"][str(seg_idx)].replace(" ", "_")

            img_parent_folder = Path(img).parent.parts[-1]
            img_ext = img_parent_folder.split("_")[-1] if "_" in img_parent_folder else ""

            seg_parent_folder = Path(seg).parent.parts[-1]
            seg_ext = seg_parent_folder.split("_")[-1] if "_" in seg_parent_folder else ""

            target_save_dir = osp.join(TARGET_DIR, dataset_name)
            target_img_dir = osp.join(target_save_dir, "imagesTr" + (f"_{img_ext}" if img_ext else ""))
            target_seg_dir = osp.join(target_save_dir, "labelsTr")
            os.makedirs(target_img_dir, exist_ok=True)
            os.makedirs(target_seg_dir, exist_ok=True)

            resample_img = osp.join(target_img_dir, osp.basename(img))
            if(not osp.exists(resample_img)):
                resample_nii(img, resample_img)
                tqdm.write("resampling...")
            img = resample_img

            target_seg_path = osp.join(
                target_seg_dir,
                cls_name + (f"_{seg_ext}" if seg_ext else ""),
                osp.basename(seg)
            )

            seg_img = nib.load(seg)    
            spacing = tuple(seg_img.header['pixdim'][1:4])
            spacing_voxel = spacing[0] * spacing[1] * spacing[2]
            seg_arr = seg_img.get_fdata()
            seg_arr[seg_arr != seg_idx] = 0
            seg_arr[seg_arr != 0] = 1
            volume = seg_arr.sum()*spacing_voxel
            if(volume<10): # TODO: select this value
                tqdm.write("skip", img)
                os.remove(img)
                continue

            reference_image = tio.ScalarImage(img)
            tqdm.write("resampling seg...")
            resample_nii(seg, target_seg_path, n=seg_idx, reference_image=reference_image, mode="nearest")
            # shutil.move(img, target_img_path)
            exit(-100)

if __name__ == "__main__":
    main()