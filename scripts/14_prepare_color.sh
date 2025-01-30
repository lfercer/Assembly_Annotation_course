#!/bin/bash
#SBATCH --job-name=Tree_phylogeny         # Job name
#SBATCH --partition=pibu_el8              # Partition (queue)
#SBATCH --cpus-per-task=4                # Number of CPUs
#SBATCH --mem=8G                         # Memory (RAM)
#SBATCH --time=01:00:00                 # Max wall time 
#SBATCH --output=/data/users/lfernandez/assembly_course/EDTA_annotation/jobs/Tree_phylo_%j.o
#SBATCH --error=/data/users/lfernandez/assembly_course/EDTA_annotation/errors/Tree_phylo_%j.e


COLOR_DIR=/data/users/lfernandez/assembly_course/EDTA_annotation/color_tree
GYPSY_DIR=/data/users/lfernandez/assembly_course/EDTA_annotation/TE_sorter_2/Gypsy_sequences.fa.rexdb-plant.cls.tsv
COPIA_DIR=/data/users/lfernandez/assembly_course/EDTA_annotation/TE_sorter_2/Copia_sequences.fa.rexdb-plant.cls.tsv
GYPSY_BRASS=/data/users/lfernandez/assembly_course/EDTA_annotation/TE_sorter_2/Gypsy_Brassicaceae_sequences.fa.rexdb-plant.cls.tsv
COPIA_BRASS=/data/users/lfernandez/assembly_course/EDTA_annotation/TE_sorter_2/Copia_Brassicaceae_sequences.fa.rexdb-plant.cls.tsv
SUMMARY_DIR=/data/users/lfernandez/assembly_course/EDTA_annotation/assembly.fasta.mod.EDTA.TEanno.sum

mkdir -p $COLOR_DIR

cd $COLOR_DIR

grep -h -e "Ale" $COPIA_DIR $COPIA_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #1f77b4 Ale/' > Ale_ID.txt

grep -h -e "Angela" $COPIA_DIR $COPIA_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #ff7f0e Angela/' > Angela_ID.txt

grep -h -e "Bianca" $COPIA_DIR $COPIA_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #2ca02c Bianca/' > Bianca_ID.txt

grep -h -e "Ikeros" $COPIA_DIR $COPIA_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #d62728 Ikeros/' > Ikeros_ID.txt

grep -h -e "Ivana" $COPIA_DIR $COPIA_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #9467bd Ivana/' > Ivana_ID.txt

grep -h -e "SIRE" $COPIA_DIR $COPIA_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #8c564b SIRE/' > SIRE_ID.txt

grep -h -e "Tork" $COPIA_DIR $COPIA_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #e377c2 Tork/' > Tork_ID.txt

grep -h -e "Athila" $GYPSY_DIR $GYPSY_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #1f77b4 Athila/' > Athila_ID.txt

grep -h -e "CRM" $GYPSY_DIR $GYPSY_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #ff7f0e CRM/' > CRM_ID.txt

grep -h -e "Reina" $GYPSY_DIR $GYPSY_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #2ca02c Reina/' > Reina_ID.txt

grep -h -e "Retand" $GYPSY_DIR $GYPSY_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #d62728 Retand/' > Retand_ID.txt

grep -h -e "Tekay" $GYPSY_DIR $GYPSY_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #9467bd Tekay/' > Tekay_ID.txt

grep -h -e "unknown" $GYPSY_DIR $GYPSY_BRASS |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #8c564b unknown/' > unknown_ID.txt

# create the counts file
tail -n +35 $SUMMARY_DIR | head -n -48 | awk '{print $1 "," $2}' > counts.txt