#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=64G
#SBATCH --time=2-00:00:00
#SBATCH --job-name=07_run_trinity
#SBATCH --error=/data/users/lfernandez/assembly_course/assembly/errors/trinity_%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/assembly/jobs/trinity_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8


WORK_DIR=/data/users/lfernandez/assembly_course
OUT_DIR=/data/users/lfernandez/assembly_course/assembly/trinity

mkdir -p $OUT_DIR

module load Trinity/2.15.1-foss-2021a
Trinity --seqType fq --left <(zcat $WORK_DIR/read_QC/fastp/ERR754081_1_trimmed.fq.gz) --right <(zcat $WORK_DIR/read_QC/fastp/ERR754081_2_trimmed.fq.gz) --CPU 12 --max_memory 64G --output $OUT_DIR