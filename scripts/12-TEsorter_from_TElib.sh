#!/bin/bash
#SBATCH --job-name=TEsorter_TElib          # Job name
#SBATCH --partition=pibu_el8              # Partition (queue)
#SBATCH --cpus-per-task=4                # Number of CPUs
#SBATCH --mem=8G                         # Memory (RAM)
#SBATCH --time=01:00:00                 # Max wall time 
#SBATCH --output=/data/users/lfernandez/assembly_course/EDTA_annotation/jobs/TEsorter_2_%j.o
#SBATCH --error=/data/users/lfernandez/assembly_course/EDTA_annotation/errors/TEsorter_2_%j.e

WORKDIR=/data/users/lfernandez/assembly_course/
EDTA_DIR=/data/users/lfernandez/assembly_course/EDTA_annotation/




module load SeqKit/2.6.1
cd $EDTA_DIR
seqkit grep -r -p "Copia" $EDTA_DIR/assembly.fasta.mod.EDTA.TElib.fa > $EDTA_DIR/Copia_sequences.fa
seqkit grep -r -p "Gypsy" $EDTA_DIR/assembly.fasta.mod.EDTA.TElib.fa > $EDTA_DIR/Gypsy_sequences.fa

cd $EDTA_DIR
apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter $EDTA_DIR/Copia_sequences.fa -db rexdb-plant

cd $EDTA_DIR
apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter $EDTA_DIR/Gypsy_sequences.fa -db rexdb-plant

# Also run TEsorter on the Brassicaceae-specific TE library, 
# you will need Brassicaceae TEs for phylogenetic analysis

cd $EDTA_DIR
seqkit grep -r -p "Copia" /data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta > Copia_Brassicaceae_sequences.fa
seqkit grep -r -p "Gypsy" /data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta > Gypsy_Brassicaceae_sequences.fa
cd $EDTA_DIR
apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter Copia_Brassicaceae_sequences.fa -db rexdb-plant 

cd $EDTA_DIR
apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter Gypsy_Brassicaceae_sequences.fa -db rexdb-plant

