SUBJECTS=$(cat <<-EOM
sub-002S0413_ses-1
sub-002S0413_ses-2
sub-002S0413_ses-3
sub-002S1155_ses-1
sub-002S1155_ses-2
sub-002S1155_ses-3
sub-002S1155_ses-4
sub-002S1261_ses-1
sub-002S1261_ses-2
sub-002S1261_ses-3
sub-002S1261_ses-4
sub-002S1280_ses-1
sub-002S4229_ses-1
sub-002S4229_ses-2
sub-002S4229_ses-3
sub-002S4229_ses-4
sub-002S4262_ses-1
sub-002S4262_ses-2
sub-002S4521_ses-1
sub-002S4521_ses-2
sub-002S4654_ses-1
sub-002S4654_ses-2
sub-002S4654_ses-3
sub-002S4799_ses-1
sub-002S4799_ses-2
sub-002S4799_ses-3
sub-002S4799_ses-4
sub-002S5178_ses-1
sub-002S5178_ses-2
sub-002S5178_ses-3
sub-002S5230_ses-1
sub-002S5230_ses-2
sub-002S5230_ses-3
sub-002S6007_ses-1
sub-002S6007_ses-3
sub-002S6009_ses-1
sub-002S6009_ses-2
sub-002S6030_ses-1
sub-002S6053_ses-1
sub-002S6053_ses-2
sub-002S6404_ses-1
sub-002S6456_ses-1
sub-003S0908_ses-1
sub-003S0908_ses-2
sub-003S0908_ses-3
sub-003S1122_ses-1
sub-003S1122_ses-2
sub-003S4119_ses-1
sub-003S4119_ses-2
sub-003S4288_ses-1
sub-003S4288_ses-2
sub-003S4288_ses-3
sub-003S4350_ses-1
sub-003S4441_ses-1
sub-003S4441_ses-2
sub-003S4644_ses-1
sub-003S4644_ses-2
sub-003S4644_ses-3
sub-003S4872_ses-1
sub-003S4900_ses-1
sub-003S4900_ses-2
sub-003S5154_ses-1
sub-003S6014_ses-1
sub-003S6014_ses-2
sub-003S6014_ses-3
sub-003S6067_ses-1
sub-003S6067_ses-2
sub-003S6067_ses-3
sub-003S6256_ses-1
sub-003S6256_ses-2
sub-003S6258_ses-1
sub-003S6258_ses-2
sub-003S6258_ses-3
sub-003S6259_ses-2
sub-003S6260_ses-1
sub-003S6260_ses-2
sub-003S6260_ses-3
sub-003S6264_ses-1
sub-003S6268_ses-1
sub-003S6268_ses-2
sub-003S6268_ses-3
sub-003S6307_ses-1
sub-003S6307_ses-2
sub-003S6307_ses-3
sub-003S6432_ses-1
sub-003S6432_ses-2
sub-003S6479_ses-1
sub-003S6606_ses-1
sub-003S6606_ses-2
sub-003S6644_ses-1
sub-003S6833_ses-1
sub-006S0498_ses-1
sub-006S0498_ses-2
sub-006S0498_ses-3
sub-006S0731_ses-1
sub-006S0731_ses-2
sub-006S0731_ses-3
sub-006S0731_ses-4
sub-006S4485_ses-1
sub-006S4485_ses-2
sub-006S4485_ses-3
sub-007S2394_ses-1
sub-007S4387_ses-3
sub-007S4488_ses-1
sub-007S4488_ses-2
sub-007S4620_ses-1
sub-007S4620_ses-2
sub-007S4620_ses-3
sub-007S4637_ses-1
sub-009S4324_ses-1
sub-009S5176_ses-1
sub-010S0419_ses-1
sub-010S4345_ses-1
sub-011S4105_ses-1
sub-011S4105_ses-2
sub-011S4278_ses-1
sub-011S4278_ses-2
sub-011S4278_ses-3
sub-011S4278_ses-4
sub-011S4278_ses-5
sub-011S4547_ses-1
sub-011S4547_ses-2
sub-011S4893_ses-1
sub-011S4893_ses-2
sub-011S6303_ses-1
sub-011S6303_ses-2
sub-011S6367_ses-1
sub-011S6367_ses-2
sub-011S6465_ses-1
sub-011S6465_ses-2
sub-011S6618_ses-1
sub-011S6714_ses-1
sub-012S4094_ses-1
sub-012S4094_ses-2
sub-012S4094_ses-3
sub-012S4094_ses-4
sub-012S4643_ses-1
sub-012S4643_ses-2
sub-012S4643_ses-3
sub-012S4643_ses-4
sub-012S6073_ses-1
sub-012S6073_ses-2
sub-012S6073_ses-3
sub-012S6073_ses-4
sub-012S6503_ses-1
sub-013S2389_ses-1
sub-013S4580_ses-1
sub-014S4401_ses-1
sub-014S4401_ses-2
sub-014S4401_ses-3
sub-014S4401_ses-4
sub-014S4576_ses-1
sub-014S4576_ses-2
sub-016S4951_ses-1
sub-016S5057_ses-1
sub-016S5057_ses-2
sub-018S2133_ses-1
sub-018S2133_ses-2
sub-018S2155_ses-1
sub-018S2155_ses-2
sub-018S2155_ses-3
sub-018S2155_ses-4
sub-018S2155_ses-6
sub-018S2180_ses-1
sub-018S2180_ses-2
sub-018S2180_ses-3
sub-018S2180_ses-4
sub-018S2180_ses-5
sub-018S2180_ses-6
sub-018S4313_ses-1
sub-018S4313_ses-2
sub-018S4399_ses-1
sub-018S4399_ses-2
sub-018S4399_ses-3
sub-018S4399_ses-4
sub-018S4400_ses-1
sub-018S4400_ses-2
sub-018S4400_ses-3
sub-018S4400_ses-4
sub-018S4400_ses-5
sub-018S4400_ses-6
sub-018S4809_ses-1
sub-018S4868_ses-1
sub-018S4868_ses-2
sub-018S4868_ses-3
sub-018S6207_ses-1
sub-018S6351_ses-1
sub-019S4293_ses-1
sub-019S4293_ses-2
sub-019S4293_ses-3
sub-019S4367_ses-1
sub-019S4367_ses-2
sub-019S4367_ses-3
sub-019S4835_ses-2
sub-019S5242_ses-1
sub-020S5140_ses-1
sub-020S5140_ses-2
sub-020S5140_ses-3
sub-020S5203_ses-1
sub-020S5203_ses-2
sub-020S5203_ses-3
sub-020S5203_ses-4
sub-020S6185_ses-1
sub-020S6185_ses-2
sub-020S6185_ses-3
sub-021S4335_ses-1
sub-021S4659_ses-1
sub-021S5177_ses-1
sub-022S2379_ses-1
sub-022S2379_ses-2
sub-022S2379_ses-3
sub-022S5004_ses-1
sub-022S5004_ses-2
sub-022S5004_ses-4
sub-022S5004_ses-5
sub-022S5004_ses-6
sub-023S4115_ses-1
sub-023S4115_ses-4
sub-023S4115_ses-5
sub-023S6346_ses-1
sub-023S6346_ses-2
sub-023S6399_ses-1
sub-023S6399_ses-2
sub-023S6400_ses-1
sub-023S6400_ses-2
sub-023S6535_ses-2
sub-023S6547_ses-1
sub-023S6547_ses-2
sub-023S6661_ses-1
sub-023S6702_ses-2
sub-023S6702_ses-3
sub-023S6702_ses-4
sub-024S2239_ses-1
sub-024S2239_ses-2
sub-024S2239_ses-3
sub-024S2239_ses-4
sub-024S4084_ses-1
sub-024S4169_ses-1
sub-024S4169_ses-2
sub-024S4674_ses-1
sub-024S4674_ses-2
sub-024S4674_ses-3
sub-024S4674_ses-4
sub-024S4674_ses-5
sub-024S4674_ses-6
sub-024S5290_ses-1
sub-024S5290_ses-2
sub-024S5290_ses-3
sub-024S5290_ses-4
sub-027S2219_ses-1
sub-027S2245_ses-1
sub-027S2245_ses-2
sub-027S2336_ses-1
sub-027S2336_ses-2
sub-027S4869_ses-1
sub-027S4919_ses-1
sub-027S4926_ses-1
sub-027S5079_ses-1
sub-027S5083_ses-1
sub-027S5083_ses-2
sub-027S5083_ses-3
sub-027S5093_ses-1
sub-027S5109_ses-1
sub-027S5118_ses-1
sub-027S5127_ses-1
sub-027S5169_ses-1
sub-027S5277_ses-1
sub-027S5288_ses-1
sub-029S2395_ses-1
sub-029S4384_ses-1
sub-031S0618_ses-1
sub-031S2018_ses-1
sub-031S2233_ses-1
sub-031S4021_ses-1
sub-031S4021_ses-2
sub-031S4149_ses-1
sub-031S4149_ses-2
sub-031S4721_ses-1
sub-032S0677_ses-1
sub-032S0677_ses-2
sub-032S0677_ses-3
sub-032S2247_ses-1
sub-032S4277_ses-1
sub-032S4277_ses-2
sub-032S4277_ses-3
sub-032S4429_ses-1
sub-032S4429_ses-2
sub-032S5289_ses-1
sub-032S5289_ses-2
sub-032S5289_ses-3
sub-032S5289_ses-4
sub-032S6211_ses-1
sub-032S6211_ses-2
sub-032S6600_ses-1
sub-032S6600_ses-2
sub-032S6602_ses-1
sub-032S6602_ses-2
sub-033S1016_ses-1
sub-033S1016_ses-2
sub-033S4177_ses-1
sub-033S4177_ses-2
sub-033S4179_ses-1
sub-033S4179_ses-2
sub-033S5198_ses-1
sub-033S5198_ses-2
sub-033S5198_ses-3
sub-033S5198_ses-4
sub-033S5198_ses-5
sub-033S5259_ses-1
sub-035S4114_ses-1
sub-035S4114_ses-2
sub-035S4114_ses-3
sub-035S4114_ses-4
sub-035S4114_ses-5
sub-035S4414_ses-1
sub-035S4464_ses-1
sub-035S4464_ses-2
sub-035S4464_ses-3
sub-035S4785_ses-1
sub-035S4785_ses-2
sub-035S4785_ses-3
sub-035S4785_ses-4
sub-035S4785_ses-5
sub-035S4785_ses-6
sub-035S6200_ses-1
sub-035S6200_ses-2
sub-035S6306_ses-1
sub-035S6306_ses-2
sub-035S6306_ses-3
sub-035S6480_ses-1
sub-035S6480_ses-2
sub-035S6480_ses-3
sub-035S6480_ses-4
sub-035S6488_ses-2
sub-035S6551_ses-1
sub-035S6722_ses-1
sub-035S6722_ses-2
sub-035S6739_ses-1
sub-035S6751_ses-1
sub-035S6948_ses-1
sub-036S2380_ses-1
sub-036S2380_ses-2
sub-036S2380_ses-3
sub-036S2380_ses-4
sub-036S2380_ses-5
sub-036S4491_ses-1
sub-036S4491_ses-2
sub-036S4538_ses-1
sub-036S4538_ses-2
sub-036S4538_ses-3
sub-036S4538_ses-4
sub-036S4715_ses-1
sub-036S4715_ses-2
sub-036S6134_ses-1
sub-036S6189_ses-1
sub-036S6189_ses-2
sub-036S6231_ses-1
sub-036S6316_ses-1
sub-036S6316_ses-2
sub-036S6316_ses-3
sub-036S6878_ses-1
sub-036S6878_ses-2
sub-036S6885_ses-2
sub-036S6887_ses-1
sub-036S6887_ses-2
sub-036S6894_ses-1
sub-036S6894_ses-2
sub-036S6916_ses-1
sub-036S6916_ses-2
sub-037S0303_ses-1
sub-037S0303_ses-2
sub-037S0377_ses-1
sub-037S0377_ses-2
sub-037S4214_ses-1
sub-037S4214_ses-2
sub-037S4214_ses-3
sub-037S4214_ses-4
sub-037S4214_ses-5
sub-037S4410_ses-1
sub-037S4410_ses-2
sub-037S4706_ses-1
sub-037S4706_ses-2
sub-037S4706_ses-3
sub-037S4706_ses-4
sub-037S5126_ses-1
sub-037S5126_ses-2
sub-037S5126_ses-3
sub-037S5222_ses-1
sub-037S6031_ses-1
sub-037S6031_ses-2
sub-037S6031_ses-3
sub-041S0679_ses-1
sub-041S0679_ses-2
sub-041S0679_ses-3
sub-041S0679_ses-4
sub-041S0679_ses-5
sub-041S1418_ses-1
sub-041S1418_ses-2
sub-041S1418_ses-3
sub-041S1418_ses-4
sub-041S4060_ses-1
sub-041S4200_ses-1
sub-041S4200_ses-2
sub-041S4200_ses-3
sub-041S4200_ses-4
sub-041S4271_ses-1
sub-041S4271_ses-2
sub-041S4271_ses-3
sub-041S4427_ses-1
sub-041S4427_ses-2
sub-041S4427_ses-3
sub-041S4510_ses-1
sub-041S4510_ses-2
sub-041S4513_ses-1
sub-041S4513_ses-2
sub-041S4874_ses-1
sub-041S4874_ses-2
sub-041S4874_ses-3
sub-041S4874_ses-4
sub-041S5078_ses-1
sub-041S5078_ses-2
sub-041S5078_ses-3
sub-041S5097_ses-1
sub-041S5097_ses-2
sub-041S5097_ses-3
sub-041S5097_ses-4
sub-041S5100_ses-1
sub-041S5100_ses-2
sub-041S5100_ses-3
sub-041S5100_ses-4
sub-041S5100_ses-5
sub-041S5253_ses-1
sub-041S5253_ses-2
sub-041S5253_ses-3
sub-041S5253_ses-4
sub-041S5253_ses-5
sub-041S6226_ses-1
sub-041S6226_ses-2
sub-041S6292_ses-1
sub-041S6292_ses-2
sub-041S6314_ses-1
sub-041S6314_ses-2
sub-041S6401_ses-1
sub-041S6401_ses-2
sub-041S6401_ses-3
sub-041S6731_ses-1
sub-041S6731_ses-2
sub-041S6785_ses-1
sub-041S6785_ses-2
sub-041S6785_ses-3
sub-041S6786_ses-1
sub-041S6786_ses-2
sub-041S6786_ses-3
sub-053S4578_ses-1
sub-053S4813_ses-1
sub-053S6598_ses-1
sub-053S6598_ses-2
sub-053S6598_ses-3
sub-057S5292_ses-1
sub-067S0056_ses-1
sub-067S0056_ses-2
sub-067S0056_ses-3
sub-067S0059_ses-1
sub-067S2301_ses-1
sub-067S2301_ses-2
sub-067S2301_ses-3
sub-067S2304_ses-1
sub-067S2304_ses-2
sub-067S2304_ses-3
sub-067S4212_ses-1
sub-067S4212_ses-2
sub-067S4212_ses-3
sub-067S4767_ses-1
sub-067S4767_ses-2
sub-067S4767_ses-3
sub-067S4767_ses-4
sub-067S4782_ses-1
sub-067S4782_ses-2
sub-067S4782_ses-3
sub-067S4782_ses-4
sub-068S0210_ses-1
sub-068S0210_ses-2
sub-068S2187_ses-1
sub-068S2187_ses-2
sub-068S4067_ses-1
sub-068S4332_ses-1
sub-068S4332_ses-2
sub-068S4332_ses-3
sub-068S4332_ses-4
sub-068S4424_ses-1
sub-068S4424_ses-2
sub-068S4431_ses-1
sub-068S4431_ses-2
sub-068S4431_ses-3
sub-070S4856_ses-1
sub-070S4856_ses-2
sub-073S0089_ses-1
sub-073S4216_ses-1
sub-073S4216_ses-2
sub-073S4393_ses-1
sub-073S4393_ses-2
sub-073S4552_ses-1
sub-073S4552_ses-2
sub-073S4795_ses-1
sub-082S2121_ses-1
sub-082S2121_ses-2
sub-082S2121_ses-3
sub-082S4224_ses-1
sub-082S4224_ses-2
sub-082S4224_ses-3
sub-082S4428_ses-1
sub-082S4428_ses-2
sub-082S5282_ses-1
sub-082S6197_ses-1
sub-082S6283_ses-2
sub-082S6287_ses-1
sub-082S6563_ses-1
sub-082S6564_ses-1
sub-082S6629_ses-1
sub-082S6629_ses-2
sub-094S2367_ses-1
sub-094S4162_ses-1
sub-094S4858_ses-1
sub-098S0896_ses-1
sub-098S4003_ses-1
sub-098S4275_ses-1
sub-100S0069_ses-1
sub-100S4469_ses-1
sub-100S4469_ses-2
sub-100S4469_ses-3
sub-100S4556_ses-1
sub-100S4556_ses-2
sub-100S4556_ses-3
sub-100S4556_ses-4
sub-109S4380_ses-1
sub-114S0416_ses-1
sub-114S0416_ses-2
sub-114S2392_ses-1
sub-114S2392_ses-2
sub-114S2392_ses-3
sub-114S2392_ses-4
sub-114S2392_ses-5
sub-114S2392_ses-6
sub-114S5234_ses-1
sub-114S6057_ses-1
sub-114S6057_ses-2
sub-114S6057_ses-3
sub-114S6063_ses-1
sub-114S6063_ses-2
sub-114S6063_ses-3
sub-114S6309_ses-1
sub-114S6309_ses-3
sub-114S6429_ses-1
sub-114S6429_ses-2
sub-114S6429_ses-3
sub-114S6462_ses-1
sub-114S6462_ses-2
sub-114S6462_ses-3
sub-114S6487_ses-1
sub-114S6524_ses-1
sub-114S6524_ses-2
sub-114S6813_ses-1
sub-114S6813_ses-2
sub-114S6917_ses-1
sub-116S4043_ses-1
sub-116S4043_ses-2
sub-116S4043_ses-3
sub-116S4175_ses-1
sub-116S4199_ses-1
sub-116S4199_ses-2
sub-116S4199_ses-3
sub-116S4199_ses-4
sub-116S4453_ses-1
sub-116S4453_ses-2
sub-116S4453_ses-3
sub-116S4453_ses-4
sub-116S4483_ses-1
sub-116S4483_ses-2
sub-116S4855_ses-1
sub-116S4855_ses-2
sub-116S4855_ses-3
sub-116S4855_ses-4
sub-116S4855_ses-5
sub-123S6118_ses-1
sub-123S6118_ses-2
sub-123S6118_ses-3
sub-126S0680_ses-1
sub-126S4891_ses-1
sub-126S4896_ses-1
sub-126S5214_ses-1
sub-126S5243_ses-1
sub-127S0112_ses-1
sub-127S0112_ses-2
sub-127S1427_ses-1
sub-127S2234_ses-1
sub-127S2234_ses-2
sub-127S4148_ses-1
sub-127S4197_ses-1
sub-127S4198_ses-1
sub-127S4210_ses-1
sub-127S4210_ses-2
sub-127S4301_ses-1
sub-127S5185_ses-1
sub-127S5200_ses-1
sub-127S5200_ses-2
sub-127S5228_ses-1
sub-127S5266_ses-1
sub-128S0205_ses-1
sub-128S2002_ses-1
sub-128S2130_ses-1
sub-128S2220_ses-1
sub-128S4607_ses-1
sub-128S4607_ses-2
sub-128S4742_ses-1
sub-128S4742_ses-2
sub-128S4742_ses-3
sub-128S4842_ses-1
sub-129S2332_ses-1
sub-130S0969_ses-1
sub-130S0969_ses-2
sub-130S2373_ses-1
sub-130S2373_ses-2
sub-130S2403_ses-1
sub-130S2403_ses-2
sub-130S4817_ses-1
sub-130S4817_ses-2
sub-130S4817_ses-3
sub-130S4817_ses-4
sub-130S5175_ses-1
sub-130S5175_ses-2
sub-130S5175_ses-3
sub-130S5258_ses-1
sub-130S5258_ses-2
sub-130S5258_ses-3
sub-135S4281_ses-1
sub-135S4309_ses-1
sub-135S4356_ses-1
sub-135S4446_ses-1
sub-135S4489_ses-1
sub-135S4598_ses-1
sub-135S4722_ses-1
sub-135S5113_ses-1
sub-135S5113_ses-2
sub-135S5269_ses-1
sub-135S5273_ses-1
sub-137S4351_ses-1
sub-137S4482_ses-1
sub-137S4482_ses-2
sub-137S4482_ses-3
sub-137S4520_ses-1
sub-137S4520_ses-2
sub-137S4520_ses-3
sub-137S4520_ses-4
sub-137S4520_ses-5
sub-137S4587_ses-1
sub-137S4631_ses-1
sub-137S4631_ses-2
sub-137S4631_ses-3
sub-137S4631_ses-4
sub-137S4862_ses-1
sub-137S4862_ses-2
sub-141S0767_ses-1
sub-141S0767_ses-2
sub-141S0767_ses-3
sub-141S1052_ses-5
sub-141S1378_ses-1
sub-141S1378_ses-2
sub-141S2333_ses-1
sub-141S2333_ses-2
sub-141S4160_ses-1
sub-141S4160_ses-2
sub-141S6008_ses-1
sub-141S6008_ses-2
sub-168S6049_ses-1
sub-168S6049_ses-2
sub-168S6051_ses-1
sub-168S6051_ses-2
sub-168S6059_ses-1
sub-168S6065_ses-1
sub-168S6085_ses-1
sub-168S6085_ses-2
sub-168S6151_ses-1
sub-168S6151_ses-2
sub-168S6151_ses-3
sub-168S6233_ses-1
sub-168S6233_ses-2
sub-168S6318_ses-1
sub-168S6320_ses-1
sub-168S6320_ses-2
sub-168S6320_ses-3
sub-168S6321_ses-1
sub-168S6321_ses-2
sub-168S6371_ses-1
sub-168S6371_ses-2
sub-168S6413_ses-1
sub-168S6413_ses-2
sub-168S6426_ses-1
sub-168S6426_ses-2
sub-168S6492_ses-1
sub-168S6634_ses-1
sub-168S6634_ses-2
sub-168S6634_ses-3
sub-168S6735_ses-1
sub-168S6754_ses-1
sub-168S6754_ses-2
sub-168S6754_ses-3
sub-168S6828_ses-1
sub-168S6843_ses-1
sub-177S6335_ses-1
sub-177S6335_ses-2
sub-301S6224_ses-1
sub-301S6592_ses-1
sub-301S6592_ses-2
sub-301S6615_ses-1
sub-301S6615_ses-2
sub-301S6777_ses-1
sub-305S6157_ses-1
sub-305S6157_ses-2
sub-305S6188_ses-1
sub-305S6313_ses-1
sub-305S6313_ses-2
sub-305S6498_ses-1
sub-305S6498_ses-2
sub-305S6498_ses-3
sub-305S6742_ses-1
sub-305S6742_ses-2
sub-305S6850_ses-1
sub-305S6850_ses-2
sub-305S6877_ses-1
sub-305S6877_ses-2
sub-941S4036_ses-1
sub-941S4036_ses-2
sub-941S4036_ses-3
sub-941S4100_ses-1
sub-941S4187_ses-1
sub-941S4187_ses-2
sub-941S4187_ses-3
sub-941S4292_ses-1
sub-941S4292_ses-2
sub-941S4292_ses-3
sub-941S4292_ses-4
sub-941S4365_ses-1
sub-941S4365_ses-2
sub-941S4365_ses-3
sub-941S4365_ses-4
sub-941S4376_ses-1
sub-941S5193_ses-1
sub-941S5193_ses-2
sub-941S5193_ses-3
EOM
)

for SUBJECT in $SUBJECTS; do
  mkdir /home/arinaldi/project/aiconsgrp/data/ADNI/${SUBJECT}
  cp /project/aiconsgrp/pkang/adni/processed/freesurfer/${SUBJECT}/mri/* /home/arinaldi/project/aiconsgrp/data/ADNI/${SUBJECT}
done

for SUBJECT in $SUBJECTS; do
  for FILE in "aseg" "brain"; do
    FS_LICENSE=~/.freesurfer/license.txt mri_convert /home/arinaldi/project/aiconsgrp/data/ADNI/${SUBJECT}/${FILE}.mgz /home/arinaldi/project/aiconsgrp/data/ADNI/${SUBJECT}/${FILE}.nii.gz
  done
done

for SUBJECT in $SUBJECTS; do
  cp /home/arinaldi/project/aiconsgrp/data/ADNI/${SUBJECT}/brain.nii.gz /home/arinaldi/project/aiconsgrp/data/ADNI/imagesTr/${SUBJECT}.nii.gz
  cp /home/arinaldi/project/aiconsgrp/data/ADNI/${SUBJECT}/aseg.nii.gz /home/arinaldi/project/aiconsgrp/data/ADNI/labelsTr/${SUBJECT}.nii.gz
done