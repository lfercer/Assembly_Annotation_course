#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1GB
#SBATCH --time=01:00:00
#SBATCH --job-name=01_run_fastqc
#SBACTH --error=/data/users/lfernandez/assembly_course/read_QC/errors/error%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/read_QC/jobs/slurm_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --partition=pibu_el8

WORK_DIR=/data/courses/assembly-annotation-course/raw_data/Est-0
OUT_DIR=/data/users/lfernandez/assembly_course/read_QC
CONTAINER_DIR=/containers/apptainer

mkdir -p $OUT_DIR

apptainer exec --bind $WORK_DIR $CONTAINER_DIR/fastqc-0.12.1.sif fastqc -o $OUT_DIR $WORK_DIR/ERR11437308.fastq.gz




