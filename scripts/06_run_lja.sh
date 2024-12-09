#!/usr/bin/env bash

#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=64GB
#SBATCH --time=3-00:00:00
#SBATCH --job-name=06_run_lja
#SBATCH --error=/data/users/lfernandez/assembly_course/assembly/errors/error%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/assembly/jobs/slurm_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --partition=pibu_el8


WORK_DIR=/data/users/lfernandez/assembly_course
OUT_DIR=/data/users/lfernandez/assembly_course/assembly/lja
CONTAINER_DIR=/containers/apptainer

mkdir -p $OUT_DIR

apptainer exec --bind $WORK_DIR $CONTAINER_DIR/lja-0.2.sif \
lja --diploid -t 32 -o $OUT_DIR --reads $WORK_DIR/Est-0/ERR11437308.fastq.gz