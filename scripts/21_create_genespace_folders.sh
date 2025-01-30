#!/usr/bin/env bash

#SBATCH --cpus-per-task=20
#SBATCH --mem=40G
#SBATCH --time=06:00:00
#SBATCH --job-name=genespace
#SBATCH --output=/data/users/lfernandez/assembly_course/annotation_evaluation/jobs/Genespace_%j.out
#SBATCH --error=/data/users/lfernandez/assembly_course/annotation_evaluation/errors/Genescpace_%j.err
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/lfernandez/assembly_course"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
FAI_FILE="/data/users/lfernandez/assembly_course/assembly/flye/assembly.fasta.fai"
GENE_FILE="/data/users/lfernandez/assembly_course/MAKER_annotation/final/filtered.genes.renamed.final.gff3"
PROTEIN_FILE="/data/users/lfernandez/assembly_course/MAKER_annotation/final/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.longest.fasta"

# load modules
module load SeqKit/2.6.1

mkdir -p $WORKDIR/annotation_evaluation/genespace/peptide
mkdir -p $WORKDIR/annotation_evaluation/genespace/bed

cd $WORKDIR/annotation_evaluation/genespace

## prepare the input files
# get 20 longest contigs
sort -k2,2 $FAI_FILE | cut -f1 | head -n20 > longest_contigs.txt

# create a bed file of all genes in the 20 longest contigs
grep -f longest_contigs.txt $GENE_FILE | awk 'NR > 1 && $3 == "gene" {gene_name = substr($9, 4, 13); print $1, $4, $5, gene_name}' > bed/Est-0.bed

# Remove the trailing semicolon in the last column of genome1.bed
sed -i 's/;$//' bed/genome1.bed

# create a fasta file of these proteins
cut -f4 -d" " bed/genome1.bed > gene_list.txt
sed 's/-R.*//' $PROTEIN_FILE | seqkit grep -f gene_list.txt > peptide/Est-0.fa

# copy the reference Arabidopsis files
cp $COURSEDIR/data/TAIR10.bed bed/
cp $COURSEDIR/data/TAIR10.fa peptide/

# copy the files from other accessions to compare
cp /data/users/rzahri/annotation_course/output/genespace/bed/genome1.bed /data/users/lfernandez/assembly_course/annotation_evaluation/genespace/bed/Stw-0.bed
cp /data/users/rzahri/annotation_course/output/genespace/peptide/genome1.fa /data/users/lfernandez/assembly_course/annotation_evaluation/genespace/peptide/Stw-0.fa
# cp /data/users/tschiller/annotation_course/final/genespace/bed/genome1.bed /data/users/lfernandez/assembly_course/annotation_evaluation/genespace/peptide/RRS10.bed
# cp /data/users/tschiller/annotation_course/final/genome1_peptide.fa /data/users/lfernandez/assembly_course/annotation_evaluation/genespace/peptide/RRS10.fa