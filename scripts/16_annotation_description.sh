#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=01:00:00
#SBATCH --job-name=describe_annotation
#SBATCH --output=/data/users/lfernandez/assembly_course/MAKER_annotation/jobs/describe_anno%j.o
#SBATCH --error=/data/users/lfernandez/assembly_course/MAKER_annotation/errors/describe_anno%j.e
#SBATCH --partition=pibu_el8

ANNOTATION=/data/users/lfernandez/assembly_course/MAKER_annotation/final/filtered.genes.renamed.final.gff3
OUTPUT_DIR=/data/users/lfernandez/assembly_course/MAKER_annotation

#number of genes
awk '$3 == "gene" {count++} END {print "gene: " count}' $ANNOTATION > $OUTPUT_DIR/stats.txt

#number of mRNAs
awk '$3 == "mRNA" {count++} END {print "mRNA: " count}' $ANNOTATION >> $OUTPUT_DIR/stats.txt

#number of genes with functional annotation
awk '$3 == "gene" {print $9}' $ANNOTATION | grep -c "InterPro" >> $OUTPUT_DIR/stats.txt

# median, max, min of gene length, mRNA length, exon length
awk '$3 == "gene" { print $5 - $4 + 1 }' $ANNOTATION > $OUTPUT_DIR/gene_lengths.txt
awk '$3 == "mRNA" { print $5 - $4 + 1 }' $ANNOTATION > $OUTPUT_DIR/mRNA_lengths.txt
awk '$3 == "exon" { print $5 - $4 + 1 }' $ANNOTATION > $OUTPUT_DIR/exon_lengths.txt

# intron lengths
awk '$3 == "exon" { split($9, a, ";"); 
    for (i in a) if (a[i] ~ /^Parent=/) parent=substr(a[i], 8);
    print parent, $4, $5 }' $ANNOTATION | sort -k1,1 -k2,2n | \
awk '{ if ($1 == prev_parent) {
        intron_length = $2 - prev_end - 1;
        print intron_length
    }
    prev_parent = $1;
    prev_end = $3}' > $OUTPUT_DIR/intron_lengths.txt

# number of exons per gene
awk '$3 == "exon" { split($9, a, ";"); 
    for (i in a) if (a[i] ~ /^Parent=/) parent=substr(a[i], 8);
    print parent }' $ANNOTATION | sort | uniq -c > $OUTPUT_DIR/exon_counts.txt

# number of monoexonic genes
awk '$1==1 {single_exon_count++} END {print single_exon_count}' $OUTPUT_DIR/exon_counts.txt > $OUTPUT_DIR/monoexonic_genes.txt
