#!/bin/bash
#SBATCH --job-name=TE_phylogeny         # Job name
#SBATCH --partition=pibu_el8              # Partition (queue)
#SBATCH --cpus-per-task=4                # Number of CPUs
#SBATCH --mem=8G                         # Memory (RAM)
#SBATCH --time=01:00:00                 # Max wall time 
#SBATCH --output=/data/users/lfernandez/assembly_course/EDTA_annotation/jobs/phylo_%j.o
#SBATCH --error=/data/users/lfernandez/assembly_course/EDTA_annotation/errors/phylo_%j.e

WORKDIR=/data/users/lfernandez/assembly_course/
TE_DIR=/data/users/lfernandez/assembly_course/EDTA_annotation/TE_sorter_2


module load SeqKit/2.6.1
module load Clustal-Omega/1.2.4-GCC-10.3.0
module load FastTree/2.1.11-GCCcore-10.3.0

# Extract RT sequences for Copia (Ty1-RT) from Arabidopsis
grep Ty1-RT $TE_DIR/Copia_sequences.fa.rexdb-plant.dom.faa > $TE_DIR/copia_list.txt #make a list of RT proteins to extract
sed -i 's/>//' $TE_DIR/copia_list.txt #remove ">" from the header
sed -i 's/ .\+//' $TE_DIR/copia_list.txt #remove all characters following "empty space" from the header
seqkit grep -f $TE_DIR/copia_list.txt $TE_DIR/Copia_sequences.fa.rexdb-plant.dom.faa -o $TE_DIR/Copia_RT.fasta


# Extract RT sequences for Gypsy (Ty3-RT) from Arabidopsis
grep Ty3-RT $TE_DIR/Gypsy_sequences.fa.rexdb-plant.dom.faa > $TE_DIR/gypsy_list.txt #make a list of RT proteins to extract
sed -i 's/>//' $TE_DIR/gypsy_list.txt #remove ">" from the header
sed -i 's/ .\+//' $TE_DIR/gypsy_list.txt #remove all characters following "empty space" from the header
seqkit grep -f $TE_DIR/gypsy_list.txt $TE_DIR/Gypsy_sequences.fa.rexdb-plant.dom.faa -o $TE_DIR/Gypsy_RT.fasta


# Extract RT sequences for Copia (Ty1-RT) from Brassicaceae
grep Ty1-RT $TE_DIR/Copia_Brassicaceae_sequences.fa.rexdb-plant.dom.faa > $TE_DIR/copia_brass_list.txt
sed -i 's/>//' $TE_DIR/copia_brass_list.txt
sed -i 's/ .\+//' $TE_DIR/copia_brass_list.txt
seqkit grep -f $TE_DIR/copia_brass_list.txt $TE_DIR/Copia_Brassicaceae_sequences.fa.rexdb-plant.dom.faa -o $TE_DIR/Copia_brass_RT.fasta

# Extract RT sequences for Gypsy (Ty3-RT) from Brassicaceae
grep Ty3-RT $TE_DIR/Gypsy_Brassicaceae_sequences.fa.rexdb-plant.dom.faa > $TE_DIR/gypsy_brass_list.txt
sed -i 's/>//' $TE_DIR/gypsy_brass_list.txt
sed -i 's/ .\+//' $TE_DIR/gypsy_brass_list.txt
seqkit grep -f $TE_DIR/gypsy_brass_list.txt $TE_DIR/Gypsy_Brassicaceae_sequences.fa.rexdb-plant.dom.faa -o $TE_DIR/Gypsy_brass_RT.fasta

# Concatenate RT Sequences from Brassicaceae and Arabidopsis
cat $TE_DIR/Copia_RT.fasta $TE_DIR/Copia_brass_RT.fasta > $TE_DIR/All_Copia_RT.fasta
cat $TE_DIR/Gypsy_RT.fasta $TE_DIR/Gypsy_brass_RT.fasta > $TE_DIR/All_Gypsy_RT.fasta

# Shorten the TE identifiers and replace : with _
sed -i 's/#.\+//' $TE_DIR/All_Copia_RT.fasta
sed -i 's/|.\+//' $TE_DIR/All_Copia_RT.fasta

sed -i 's/#.\+//' $TE_DIR/All_Gypsy_RT.fasta
sed -i 's/|.\+//' $TE_DIR/All_Gypsy_RT.fasta

# Clustal Omega for multiple sequence alignment
clustalo -i $TE_DIR/All_Copia_RT.fasta -o $TE_DIR/Copia_RT_aligned.fasta --outfmt=fasta
clustalo -i $TE_DIR/All_Gypsy_RT.fasta -o $TE_DIR/Gypsy_RT_aligned.fasta --outfmt=fasta

# FastTree to build phylogenetic trees
FastTree -out $TE_DIR/Copia_tree.nwk $TE_DIR/Copia_RT_aligned.fasta
FastTree -out $TE_DIR/Gypsy_tree.nwk $TE_DIR/Gypsy_RT_aligned.fasta