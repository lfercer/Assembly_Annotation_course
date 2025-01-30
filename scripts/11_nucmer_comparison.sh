#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=11_nucmer_comparison
#SBATCH --error=/data/users/lfernandez/assembly_course/comparison/errors/trinity_%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/comparison/jobs/trinity_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8


WORK_DIR=/data/users/lfernandez/assembly_course
ASSEMBLY_DIR=/data/users/lfernandez/assembly_course/assembly
OUTPUT_DIR=/data/users/lfernandez/assembly_course/comparison
REFERENCE_FILE=/data/users/lfernandez/assembly_course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
CONTAINER_DIR=/containers/apptainer

mkdir -p $OUTPUT_DIR

#compare vs reference
apptainer exec --bind /data $CONTAINER_DIR/mummer4_gnuplot.sif \
nucmer --threads 6 --mincluster 1000 --breaklen 1000 --delta $OUTPUT_DIR/flye.delta $REFERENCE_FILE $ASSEMBLY_DIR/flye/assembly.fasta

apptainer exec --bind /data $CONTAINER_DIR/mummer4_gnuplot.sif \
nucmer --threads 6 --mincluster 1000 --breaklen 1000 --delta $OUTPUT_DIR/hifiasm.delta $REFERENCE_FILE $ASSEMBLY_DIR/hifiasm/ERR11437308.asm.bp.p_ctg.fa

apptainer exec --bind /data $CONTAINER_DIR/mummer4_gnuplot.sif \
nucmer --threads 6 --mincluster 1000 --breaklen 1000 --delta $OUTPUT_DIR/lja.delta $REFERENCE_FILE $ASSEMBLY_DIR/lja/assembly.fasta


# create mummerplots
apptainer exec --bind /data $CONTAINER_DIR/mummer4_gnuplot.sif \
mummerplot -R $REFERENCE_FILE -Q $ASSEMBLY_DIR/flye/assembly.fasta --fat --layout --filter --breaklen 1000 -t png --large -p $OUTPUT_DIR/flye_plot $OUTPUT_DIR/flye.delta

apptainer exec --bind /data $CONTAINER_DIR/mummer4_gnuplot.sif \
mummerplot -R $REFERENCE_FILE -Q $ASSEMBLY_DIR/hifiasm/ERR11437308.asm.bp.p_ctg.fa --fat --layout --filter --breaklen 1000 -t png --large -p $OUTPUT_DIR/hifiasm_plot $OUTPUT_DIR/hifiasm.delta

apptainer exec --bind /data $CONTAINER_DIR/mummer4_gnuplot.sif \
mummerplot -R $REFERENCE_FILE -Q $ASSEMBLY_DIR/lja/assembly.fasta --fat --layout --filter --breaklen 1000 -t png --large -p $OUTPUT_DIR/lja_plot $OUTPUT_DIR/lja.delta


# pairwise comparisons between assemblies
#flye vs hifiasm
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/mummer4_gnuplot.sif \
nucmer --threads 6 --mincluster 1000 --breaklen 1000 --delta $OUTPUT_DIR/flye_vs_hifiasm.delta $ASSEMBLY_DIR/flye/assembly.fasta $ASSEMBLY_DIR/hifiasm/ERR11437308.asm.bp.p_ctg.fa
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/mummer4_gnuplot.sif \
mummerplot -R $ASSEMBLY_DIR/flye/assembly.fasta -Q $ASSEMBLY_DIR/hifiasm/ERR11437308.asm.bp.p_ctg.fa --fat --layout --filter --breaklen 1000 -t png --large -p $OUTPUT_DIR/flye_vs_hifiasm_plot $OUTPUT_DIR/flye_vs_hifiasm.delta

#flye vs lja
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/mummer4_gnuplot.sif \
nucmer --threads 6 --mincluster 1000 --breaklen 1000 --delta $OUTPUT_DIR/flye_vs_lja.delta $ASSEMBLY_DIR/flye/assembly.fasta $ASSEMBLY_DIR/lja/assembly.fasta
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/mummer4_gnuplot.sif \
mummerplot -R $ASSEMBLY_DIR/flye/assembly.fasta -Q $ASSEMBLY_DIR/lja/assembly.fasta --fat --layout --filter --breaklen 1000 -t png --large -p $OUTPUT_DIR/flye_vs_lja_plot $OUTPUT_DIR/flye_vs_lja.delta

#hifiasm vs lja
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/mummer4_gnuplot.sif \
nucmer --threads 6 --mincluster 1000 --breaklen 1000 --delta $OUTPUT_DIR/hifiasm_vs_lja.delta $ASSEMBLY_DIR/hifiasm/ERR11437308.asm.bp.p_ctg.fa $ASSEMBLY_DIR/lja/assembly.fasta
apptainer exec --bind $WORK_DIR $CONTAINER_DIR/mummer4_gnuplot.sif \
mummerplot -R $ASSEMBLY_DIR/hifiasm/ERR11437308.asm.bp.p_ctg.fa -Q $ASSEMBLY_DIR/lja/assembly.fasta --fat --layout --filter --breaklen 1000 -t png --large -p $OUTPUT_DIR/hifiasm_vs_lja_plot $OUTPUT_DIR/hifiasm_vs_lja.delta
