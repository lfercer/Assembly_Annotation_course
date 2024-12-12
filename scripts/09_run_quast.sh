#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=64GB
#SBATCH --time=1-00:00:00
#SBATCH --job-name=09_quast
#SBATCH --error=/data/users/lfernandez/assembly_course/assembly_evaluation/errors/quast%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/assembly_evaluation/jobs/quast_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8

CONTAINER_DIR=/containers/apptainer
WORK_DIR=/data/users/lfernandez/assembly_course
OUT_DIR=/data/users/lfernandez/assembly_course/assembly_evaluation
REF_DIR=/data/users/lfernandez/assembly_course/references


mkdir -p $OUT_DIR/quast_ref
mkdir -p $OUT_DIR/quast_no_ref

module load QUAST/5.0.2-foss-2021a

# Run quast without reference genome
#apptainer exec --bind $WORK_DIR $CONTAINER_DIR/quast_5.2.0.sif \
quast.py -o $OUT_DIR/quast_no_ref --est-ref-size 164500000 --threads 6 --labels flye,lja,hifiasm --eukaryote --no-sv $WORK_DIR/assembly/flye/assembly.fasta $WORK_DIR/assembly/lja/assembly.fasta $WORK_DIR/assembly/hifiasm/ERR11437308.asm.bp.p_ctg.fa 

# Run quast with reference genome
#apptainer exec --bind $WORK_DIR $CONTAINER_DIR/quast_5.2.0.sif \
quast.py -o $OUT_DIR/quast_ref -r $REF_DIR/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz --features $REF_DIR/TAIR10_GFF3_genes.gff --est-ref-size 164500000 --threads 6 --labels flye,lja,hifiasm --eukaryote --no-sv $WORK_DIR/assembly/flye/assembly.fasta $WORK_DIR/assembly/lja/assembly.fasta $WORK_DIR/assembly/hifiasm/ERR11437308.asm.bp.p_ctg.fa 