#!/bin/bash
#SBATCH --job-name=umamba_indomain
#SBATCH --quotatype=auto
#SBATCH --partition=medai
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gpus-per-task=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=32G
#SBATCH --chdir=/mnt/petrelfs/zhaoziheng/Knowledge-Enhanced-Medical-Segmentation/nnUNet-Related-Project/nnUNet-as-MRDiffusion-Baseline/sbatch/out
#SBATCH --output=/mnt/petrelfs/zhaoziheng/Knowledge-Enhanced-Medical-Segmentation/nnUNet-Related-Project/nnUNet-as-MRDiffusion-Baseline/sbatch/out/%x-%j.out
#SBATCH --error=/mnt/petrelfs/zhaoziheng/Knowledge-Enhanced-Medical-Segmentation/nnUNet-Related-Project/nnUNet-as-MRDiffusion-Baseline/sbatch/out/%x-%j.error
###SBATCH -w SH-IDC1-10-140-0-[...], SH-IDC1-10-140-1-[...]
###SBATCH -x SH-IDC1-10-140-0-[...], SH-IDC1-10-140-1-[...]

export NCCL_DEBUG=INFO
export NCCL_IBEXT_DISABLE=1
export NCCL_IB_DISABLE=1
export NCCL_SOCKET_IFNAME=eth0
echo "NODELIST="${SLURM_NODELIST}
master_addr=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_ADDR=$master_addr
MASTER_PORT=$((RANDOM % 101 + 20000))
echo "MASTER_ADDR="$MASTER_ADDR

# Dataset949_MSDLiver_PNG

srun \
UMamba_predict -i /mnt/hwfile/medai/zhaoziheng/SAM/nnUNet_data/nnUNet_raw/Dataset949_MSDLiver_PNG/imagesTs/ \
-o /mnt/hwfile/medai/zhaoziheng/SAM/nnUNet_data/nnUNet_raw/Dataset949_MSDLiver_PNG/labelsPred_umambaBot/ \
-chk  /mnt/hwfile/medai/zhaoziheng/SAM/nnUNet_data/nnUNet_UMamba_results/Dataset949_MSDLiver_PNG/nnUNetTrainerUMambaBot__nnUNetPlans__2d/fold_all/checkpoint_best.pth \
-d 949 \
-tr nnUNetTrainerUMambaBot \
-c 2d  -f all  --disable_tta

python /mnt/petrelfs/zhaoziheng/Knowledge-Enhanced-Medical-Segmentation/nnUNet-Related-Project/nnUNet-as-MRDiffusion-Baseline/evaluate/evaluate_nib.py \
--target_dataset 'MSD_Liver' \
--source_dataset 'MSD_Liver' \
--nnunet_name 'Dataset949_MSDLiver_PNG' \
--gt_dir 'labelsTs' \
--seg_dir 'labelsPred' \
--img_dir 'imagesTs' 