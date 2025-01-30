#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --mem=16G
#SBATCH -p pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --job-name=orthofinder
#SBATCH --output=/data/users/lfernandez/assembly_course/annotation_evaluation/jobs/ortho_%j.out
#SBATCH --error=/data/users/lfernandez/assembly_course/annotation_evaluation/errors/ortho_%j.err

WORKDIR=/data/users/lfernandez/assembly_course/annotation_evaluation/genespace

# Load the R module
module load R/4.3.2-foss-2021a

# Set a custom library path
LIB_PATH="~/R/library"
mkdir -p $LIB_PATH  # Create the directory if it doesn't exist

# Install required packages in the specified library
Rscript -e 'install.packages("tidyverse", lib = "'$LIB_PATH'")'
Rscript -e 'install.packages("data.table", lib = "'$LIB_PATH'")'
Rscript -e 'install.packages("cowplot", lib = "'$LIB_PATH'")'
Rscript -e 'install.packages("UpSetR", lib = "'$LIB_PATH'")'
Rscript -e 'if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager", lib = "'$LIB_PATH'"); BiocManager::install("ComplexUpset", lib = "'$LIB_PATH'")'

# Change to the working directory
cd $WORKDIR

# Run the main R script, specifying the library path
Rscript -e '.libPaths(c("'$LIB_PATH'", .libPaths())); source("/data/users/lfernandez/assembly_course/scripts/24_parse_orthofinder.R")'
