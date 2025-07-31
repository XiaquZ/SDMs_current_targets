#! /bin/bash -l
#SBATCH --job-name=pred_CurrentSDMs
#SBATCH --ntasks=1 --cpus-per-task=10 --mem-per-cpu=6000mb
#SBATCH --time=21:35:00
#SBATCH -A lp_climateplants

source $VSC_HOME/.bashrc

cd $VSC_DATA/SDMs_current_targets/
export OMP_NUM_THREADS=1

source activate VoCC_R_new

Rscript targets_run_cmq.R
