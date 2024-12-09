#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=64GB
#SBATCH --time=2-00:00:00
#SBATCH --job-name=04_run_flye
#SBATCH --error=/data/users/lfernandez/assembly_course/assembly/errors/error%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/assembly/jobs/slurm_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --partition=pibu_el8


WORK_DIR=/data/users/lfernandez/assembly_course
OUT_DIR=/data/users/lfernandez/assembly_course/assembly/flye
CONTAINER_DIR=/containers/apptainer

mkdir -p $OUT_DIR

apptainer exec --bind $WORK_DIR $CONTAINER_DIR/flye_2.9.5.sif \
flye --pacbio-hifi $WORK_DIR/Est-0/ERR11437308.fastq.gz \
-o $OUT_DIR