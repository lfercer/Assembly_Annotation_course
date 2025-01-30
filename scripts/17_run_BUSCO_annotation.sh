#!/usr/bin/env bash

#SBATCH --cpus-per-task=20
#SBATCH --mem=40G
#SBATCH --time=06:00:00
#SBATCH --job-name=busco_annotation
#SBATCH --output=/data/users/lfernandez/assembly_course/annotation_evaluation/jobs/BUSCO%j.o
#SBATCH --error=/data/users/lfernandez/assembly_course/annotation_evaluation/errors/BUSCO%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/lfernandez/assembly_course/MAKER_annotation/final
OUTDIR=/data/users/lfernandez/assembly_course/annotation_evaluation
PLOTDIR=/data/users/lfernandez/assembly_course/annotation_evaluation/busco

mkdir -p $OUTDIR
mkdir -p $PLOTDIR
mkdir -p $OUTDIR/transcripts
mkdir -p $OUTDIR/proteins

# load the modules
module load BUSCO/5.4.2-foss-2021a
module load SeqKit/2.6.1

# create file with the longest transcripts
seqkit fx2tab -nl $WORKDIR/assembly.all.maker.fasta.all.maker.transcripts.fasta.renamed.filtered.fasta > $OUTDIR/transcript_lengths.tsv
sort -k1,1 -k2,2nr $OUTDIR/transcript_lengths.tsv | \
awk '{
   gene = gensub(/ .*/, "", "g", $1); # Assuming space separates gene ID
   if (gene != last_gene) {
       print $1;
        last_gene = gene;
    }
}' > $OUTDIR/longest_transcripts.txt

seqkit grep -f $OUTDIR/longest_transcripts.txt $WORKDIR/assembly.all.maker.fasta.all.maker.transcripts.fasta.renamed.filtered.fasta > $WORKDIR/assembly.all.maker.fasta.all.maker.transcripts.fasta.renamed.filtered.longest.fasta

# same for proteins
seqkit fx2tab -nl $WORKDIR/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.fasta > $OUTDIR/protein_lengths.tsv
sort -k1,1 -k2,2nr $OUTDIR/protein_lengths.tsv | \
awk '{
    gene = gensub(/ .*/, "", "g", $1); # Assuming space separates gene ID
    if (gene != last_gene) {
        print $1;
        last_gene = gene;
    }
}' > $OUTDIR/longest_proteins.txt

seqkit grep -f $OUTDIR/longest_proteins.txt $WORKDIR/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.fasta > $WORKDIR/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.longest.fasta

# run BUSCO on the longest proteins and longest transcripts
busco -i  $WORKDIR/assembly.all.maker.fasta.all.maker.transcripts.fasta.renamed.filtered.longest.fasta -l brassicales_odb10 -o $OUTDIR/transcripts -m transcriptome -f
busco -i $WORKDIR/assembly.all.maker.fasta.all.maker.proteins.fasta.renamed.filtered.longest.fasta -l brassicales_odb10 -o $OUTDIR/proteins -m proteins -f

## create busco plot
# copy the busco short_summary files to the plot folder
cp /data/users/lfernandez/assembly_course/data/users/lfernandez/assembly_course/annotation_evaluation/transcripts/short_summary.specific.brassicales_odb10.transcripts.txt $PLOTDIR/.
cp /data/users/lfernandez/assembly_course/data/users/lfernandez/assembly_course/annotation_evaluation/proteins/short_summary.specific.brassicales_odb10.proteins.txt $PLOTDIR/.

# move to the plot directory and download the generate_plot.py script from the BUSCO GitHub
cd $PLOTDIR
#wget https://gitlab.com/ezlab/busco/-/raw/master/scripts/generate_plot.py

python3 generate_plot.py -wd $PLOTDIR
