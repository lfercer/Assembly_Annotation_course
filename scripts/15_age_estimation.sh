#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=01:00:00
#SBATCH --job-name=TE_age_estimation
#SBATCH --output=/data/users/lfernandez/assembly_course/EDTA_annotation/jobs/age_est_%j.o
#SBATCH --error=/data/users/lfernandez/assembly_course/EDTA_annotation/errors/age_est_%j.e
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/lfernandez/assembly_course/EDTA_annotation
EDTA_DIR=/data/users/lfernandez/assembly_course/EDTA_annotation/assembly.fasta.mod.EDTA.anno
SCRIPT_DIR=/data/users/lfernandez/assembly_course/scripts

cd $WORK_DIR


# make script executable
chmod +x $SCRIPT_DIR/parseRM.pl

# load the module and run the script
module add BioPerl/1.7.8-GCCcore-10.3.0
perl $SCRIPT_DIR/parseRM.pl -i $EDTA_DIR/assembly.fasta.mod.out -l 50,1 -v > $EDTA_DIR/parsed_TE_divergence_output.tsv