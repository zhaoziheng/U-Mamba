srun1g \
nnUNetv2_predict \
-i '/mnt/hwfile/medai/zhaoziheng/SAM/nnUNet_data/nnUNet_raw/Dataset016_BTCV/imagesTs' \
-o '/mnt/hwfile/medai/zhaoziheng/SAM/nnUNet_data/nnUNet_raw/Dataset016_BTCV/labelsPred_UMambaBot' \
-chk '/mnt/hwfile/medai/zhaoziheng/SAM/nnUNet_data/nnUNet_UMamba_results/Dataset016_BTCV/nnUNetTrainerUMambaBot__nnUNetPlans__3d_fullres/fold_all/checkpoint_best.pth' \
-d 16 \
-c 3d_fullres \
-f all \
-tr nnUNetTrainerUMambaBot \
--disable_tta

srun0g \
python /mnt/petrelfs/zhaoziheng/Knowledge-Enhanced-Medical-Segmentation/U-Mamba/as_SAT_baseline/evaluate_UMambaBot.py \
--dataset 'Dataset016_BTCV'