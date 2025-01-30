#!/usr/bin/env bash

#SBATCH --partition=pibu_el8
#SBATCH --job-name=12_faidx
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --output=/data/users/lfernandez/assembly_course/EDTA_annotation/jobs/faidx_%j.o
#SBATCH --error=/data/users/lfernandez/assembly_course/EDTA_annotation/errors/faidx_%j.e

# load modules
module load SAMtools/1.13-GCC-10.3.0

# set variables
WORK_DIR=/data/users/lfernandez/assembly_course/assembly/flye
ASSEMBLY_HIFIASM=/data/users/lfernandez/assembly_course/assembly/flye/assembly.fasta

cd $WORK_DIR

samtools faidx $ASSEMBLY_HIFIASM