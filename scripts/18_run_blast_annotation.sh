#!/usr/bin/env bash

#SBATCH --cpus-per-task=20
#SBATCH --mem=40G
#SBATCH --time=06:00:00
#SBATCH --job-name=blast_evaluation
#SBATCH --output=/data/users/lfernandez/assembly_course/MAKER_annotation/jobs/BLAST%j.o
#SBATCH --error=/data/users/lfernandez/assembly_course/MAKER_annotation/errors/BLAST%j.e
#SBATCH --partition=pibu_el8

OUTDIR=/data/users/lfernandez/assembly_course/annotation_evaluation/blast
WORKDIR=/data/users/lfernandez/assembly_course/MAKER_annotation/final
REFDIR="/data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa"
MAKERBIN="/data/courses/assembly-annotation-course/CDS_annotation/softwares/Maker_v3.01.03/src/bin"

mkdir -p $OUTDIR

# load module
module load BLAST+/2.15.0-gompi-2021a

blastp -query $WORKDIR/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.fasta -db $REFDIR -num_threads 10 -outfmt 6 -evalue 1e-10 -out $OUTDIR/blastp_output

cp $WORKDIR/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.fasta $WORKDIR/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.fasta.Uniprot
cp $WORKDIR/filtered.genes.renamed.final.gff3 $WORKDIR/filtered.genes.renamed.final.gff3.Uniprot
$MAKERBIN/maker_functional_fasta $REFDIR $OUTDIR/blastp_output $WORKDIR/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.fasta > $WORKDIR/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.fasta.Uniprot
$MAKERBIN/maker_functional_gff $REFDIR $OUTDIR/blastp_output $WORKDIR/filtered.genes.renamed.final.gff3 > $WORKDIR/filtered.genes.renamed.final.gff3.Uniprot