#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=64GB
#SBATCH --time=1-00:00:00
#SBATCH --job-name=10_merqury
#SBATCH --error=/data/users/lfernandez/assembly_course/assembly_evaluation/errors/merqury%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/assembly_evaluation/jobs/merqury_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8

CONTAINER_DIR=/containers/apptainer
WORK_DIR=/data/users/lfernandez/assembly_course
OUT_DIR=/data/users/lfernandez/assembly_course/assembly_evaluation/merqury
GENOME_FILE=/data/users/lfernandez/assembly_course/Est-0/ERR11437308.fastq.gz


mkdir -p $OUT_DIR

export MERQURY="/usr/local/share/merqury"

#Get right k size
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/merqury_1.3.sif \
sh $MERQURY/best_k.sh 164000000 

#result: tolerable collision rate: 0.001, k=18.6267
#Build meryl 
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/merqury_1.3.sif \
meryl k=18 count $GENOME_FILE output $OUT_DIR/genome.meryl

cd $OUT_DIR
#For fly assembly
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/merqury_1.3.sif \
sh $MERQURY/merqury.sh $OUT_DIR/genome.meryl $WORK_DIR/assembly/flye/assembly.fasta flye

cd $OUT_DIR
#For hifiasm
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/merqury_1.3.sif \
sh $MERQURY/merqury.sh $OUT_DIR/genome.meryl $WORK_DIR/assembly/hifiasm/ERR11437308.asm.bp.p_ctg.fa hifiasm

cd $OUT_DIR
#For LJA
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/merqury_1.3.sif \
sh $MERQURY/merqury.sh $OUT_DIR/genome.meryl $WORK_DIR/assembly/lja/assembly.fasta lja