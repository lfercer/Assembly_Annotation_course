#!/usr/bin/env bash


#SBATCH --time=1-0
#SBATCH --mem=64G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --job-name=OMArk
#SBATCH --output=/data/users/lfernandez/assembly_course/annotation_evaluation/jobs/OMArk%j.o
#SBATCH --error=/data/users/lfernandez/assembly_course/annotation_evaluation/errors/OMArk%j.e
#SBATCH --partition=pibu_el8

OUTDIR=/data/users/lfernandez/assembly_course/annotation_evaluation/omark
protein_input=/data/users/lfernandez/assembly_course/MAKER_annotation/final/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.fasta
isoform_list=/data/users/lfernandez/assembly_course/annotation_evaluation/omark/all_isoforms_splice.txt


mkdir -p $OUTDIR


#use andrew's environment
#eval "$(/home/amaalouf/miniconda3/bin/conda shell.bash hook)"
#conda activate OMArk
#also install omadb and gffutils module
#pip install omadb
#pip install gffutils

#download OMA DB
#wget https://omabrowser.org/All/LUCA.h5

cd $OUTDIR
omamer search --db $OUTDIR/LUCA.h5 --query ${protein_input} --out ${protein_input}.omamer

#run OMArk
omark -f ${protein_input}.omamer\
 -of ${protein_input}\
  -i $isoform_list\
   -d LUCA.h5\
    -o omark_output







