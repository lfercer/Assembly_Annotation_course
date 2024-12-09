#!/usr/bin/env bash

#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=50GB
#SBATCH --time=10:00:00
#SBATCH --job-name=02_run_fastp
#SBATCH --error=/data/users/lfernandez/assembly_course/read_QC/errors/error%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/read_QC/jobs/slurm_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/lfernandez/assembly_course
OUT_DIR=/data/users/lfernandez/assembly_course/read_QC/fastp
CONTAINER_DIR=/containers/apptainer

mkdir -p $OUT_DIR

apptainer exec --bind $WORK_DIR $CONTAINER_DIR/fastp_0.23.2--h5f740d0_3.sif \
fastp -i $WORK_DIR/Est-0/ERR11437308.fastq.gz -o $OUT_DIR/ERR11437308_trimmed.fq.gz --disable_length_filtering -h $OUT_DIR/genome_trimmed.html

#To run RNAseq samples
#fastp -i $WORK_DIR/RNAseq_Sha/ERR754081_1.fastq.gz -I $WORK_DIR/RNAseq_Sha/ERR754081_2.fastq.gz -o $OUT_DIR/ERR754081_1_trimmed.fq.gz -O $OUT_DIR/ERR754081_2_trimmed.fq.gz -h $OUT_DIR/trns_trimmed.html \