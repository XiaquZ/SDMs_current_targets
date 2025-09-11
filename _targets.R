# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.
library(clustermq)

## Running on HPC
# Settings for clustermq
options(
  clustermq.scheduler = "slurm",
  clustermq.template = "./cmq.tmpl" # if using your own template
)

# # Running locally on Windows
# options(clustermq.scheduler = "multiprocess")

## Settings for clustermq template when running clustermq on HPC
tar_option_set(
  resources = tar_resources(
    clustermq = tar_resources_clustermq(template = list(
      job_name = "Current-SDMs",
      per_cpu_mem = "5000mb",
      n_tasks = 1,
      per_task_cpus = 36,
      walltime = "20:00:00"
    ))
  )
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
tar_plan(
  # Load the required paths
  input_folders = list(
    cec = "/lustre1/scratch/348/vsc34871/SDM_current/pred_tiles/cec/",
    CHELSA_bio12_EU_2000.2019 = "/lustre1/scratch/348/vsc34871/SDM_current/pred_tiles/CHELSA_bio12_EU_2000.2019/",
    CHELSA_bio15_EU_2000.2019 = "/lustre1/scratch/348/vsc34871/SDM_current/pred_tiles/CHELSA_bio15_EU_2000.2019/",
    clay = "/lustre1/scratch/348/vsc34871/SDM_current/pred_tiles/clay/",
    Elevation = "/lustre1/scratch/348/vsc34871/SDM_current/pred_tiles/Elevation/",
    Micro_BIO5_EU_CHELSAbased_2000.2020 = "/lustre1/scratch/348/vsc34871/SDM_current/pred_tiles/Micro_BIO5_EU_CHELSAbased_2000.2020/",
    Micro_BIO6_EU_CHELSAbased_2000.2020 = "/lustre1/scratch/348/vsc34871/SDM_current/pred_tiles/Micro_BIO6_EU_CHELSAbased_2000.2020/",
    Slope = "/lustre1/scratch/348/vsc34871/SDM_current/pred_tiles/Slope/",
    TWI = "/lustre1/scratch/348/vsc34871/SDM_current/pred_tiles/TWI/",
    phh2o_0_30_WeightedMean = "/lustre1/scratch/348/vsc34871/SDM_current/pred_tiles/phh2o_0_30_WeightedMean/"
  ),
  tar_target(mdl_paths,
             list.files(
               "/lustre1/scratch/348/vsc34871/SDM_current/Models03/",
               full.names = TRUE
             )),
  # Make future species distributions
  tar_target(CurrentSDMs,
             predict_CurrentSDM(input_folders, mdl_paths),
             pattern = map(mdl_paths)
  )
)
