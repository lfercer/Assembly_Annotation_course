#!/usr/bin/env bash

#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=50GB
#SBATCH --time=05:00:00
#SBATCH --job-name=03_count_kmers
#SBATCH --error=/data/users/lfernandez/assembly_course/read_QC/errors/error%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/read_QC/jobs/slurm_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --partition=pibu_el8


WORK_DIR=/data/users/lfernandez/assembly_course
OUT_DIR=/data/users/lfernandez/assembly_course/read_QC/kmer_count
CONTAINER_DIR=/containers/apptainer

mkdir -p $OUT_DIR

#For the RNASeq data
#apptainer exec --bind $WORK_DIR $CONTAINER_DIR/jellyfish:2.2.6--0 \
#jellyfish count -C -m 21 -s 5000000000 -t 4 \
#<(zcat $WORK_DIR/read_QC/fastp/ERR754081_1_trimmed.fq.gz) \
#<(zcat $WORK_DIR/read_QC/fastp/ERR754081_2_trimmed.fq.gz) \
#-o $OUT_DIR/ERR754081.jf \




#For the WGS data
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/jellyfish:2.2.6--0 \
jellyfish histo -t 10 $OUT_DIR/ERR11437308.jf  > $OUT_DIR/ERR11437308.histo

#jellyfish count -C -m 21 -s 5000000000 -t 4 \
#<(zcat $WORK_DIR/read_QC/fastp/ERR11437308_trimmed.fq.gz) \
#-o $OUT_DIR/ERR11437308.jf \