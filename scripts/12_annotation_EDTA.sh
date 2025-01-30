#!/usr/bin/env bash

#SBATCH --cpus-per-task=24
#SBATCH --mem=40G
#SBATCH --time=5-00:00:00
#SBATCH --job-name=12_annontation_EDTA
#SBATCH --error=/data/users/lfernandez/assembly_course/EDTA_annotation/errors/EDTA_%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/EDTA_annotation/jobs/EDTA_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lfernandez/assembly_course
GENOME_DIR=/data/users/lfernandez/assembly_course/assembly/flye/assembly.fasta
CONTAINER_DIR=/data/courses/assembly-annotation-course/containers2/EDTA_v1.9.6.sif

cd $WORKDIR/EDTA_annotation

apptainer exec -C -H $WORKDIR -H ${pwd}:/work --writable-tmpfs -u $CONTAINER_DIR \
EDTA.pl \
--genome $GENOME_DIR \
--species others \
--step all \
--anno 1 \
--cds /data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated \
--threads 24