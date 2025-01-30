#!/usr/bin/env bash


#SBATCH --time=1-0
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --job-name=miniprot
#SBATCH --output=/data/users/lfernandez/assembly_course/annotation_evaluation/jobs/miniprot%j.o
#SBATCH --error=/data/users/lfernandez/assembly_course/annotation_evaluation/errors/miniprotk%j.e
#SBATCH --partition=pibu_el8


WORK_DIR=/data/users/lfernandez/assembly_course/annotation_evaluation/miniprot
COURSEDIR=/data/courses/assembly-annotation-course/CDS_annotation
OMAMER_PROT=/data/users/lfernandez/assembly_course/MAKER_annotation/final/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.fasta.omamer
OMARK_OUT=/data/users/lfernandez/assembly_course/annotation_evaluation/omark/omark_output
CONTEXTUALIZE=/data/courses/assembly-annotation-course/CDS_annotation/softwares/OMArk-0.3.0/utils/omark_contextualize.py
ORIG_FA=/data/users/lfernandez/assembly_course/assembly/flye/assembly.fasta
SEQ_FASTA_1=/data/users/lfernandez/assembly_course/annotation_evaluation/miniprot/missing_HOGs.fa


mkdir -p $WORK_DIR
cd $WORK_DIR

# Download the Orthologs of fragmented and missing genes from OMArk database
# conda activate OMArk
#python $CONTEXTUALIZE fragment -m $OMAMER_PROT -o $OMARK_OUT -f fragment_HOGs
#python $CONTEXTUALIZE missing -m $OMAMER_PROT -o $OMARK_OUT -f missing_HOGs


# download and compile miniprot
#git clone https://github.com/lh3/miniprot
cd miniprot && make

# run miniprot
miniprot/miniprot -I --gff --outs=0.95 $ORIG_FA $SEQ_FASTA_1 > MINIPROT_OUTPUT.gff
