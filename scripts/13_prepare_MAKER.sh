#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=5-00:00:00
#SBATCH --job-name=13_MAKER
#SBATCH --error=/data/users/lfernandez/assembly_course/MAKER_annotation/errors/MAKER_%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/MAKER_annotation/jobs/MAKER_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8


MAKER_DIR=/data/users/lfernandez/assembly_course/MAKER_annotation
CONTAINER_DIR=/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif


mkdir -p $MAKER_DIR
cd $MAKER_DIR


#Create control files
apptainer exec --bind $MAKER_DIR $CONTAINER_DIR\
 maker -CTL

 
