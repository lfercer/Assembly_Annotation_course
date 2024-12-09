#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=64GB
#SBATCH --time=1-00:00:00
#SBATCH --job-name=05_run_hifiasm
#SBATCH --error=/data/users/lfernandez/assembly_course/assembly/errors/error%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/assembly/jobs/slurm_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --partition=pibu_el8


WORK_DIR=/data/users/lfernandez/assembly_course
OUT_DIR=/data/users/lfernandez/assembly_course/assembly/hifiasm
CONTAINER_DIR=/containers/apptainer

mkdir -p $OUT_DIR

apptainer exec --bind $WORK_DIR $CONTAINER_DIR/hifiasm_0.19.8.sif \
hifiasm -o $OUT_DIR/ERR11437308.asm -t 32 $WORK_DIR/Est-0/ERR11437308.fastq.gz

cd $OUT_DIR
for file in *.gfa; do
    awk '/^S/{print ">"$2;print $3}' "$file" > "${file%.gfa}.fa";
done
