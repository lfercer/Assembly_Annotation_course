#!/bin/bash
#SBATCH --time=1-0
#SBATCH --mem=64G
#SBATCH -p pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --job-name=Genespace
#Sbatch --output=/data/users/lfernandez/assembly_course/annotation_evaluation/jobs/Genespace_%j.out
#Sbatch --error=/data/users/lfernandez/assembly_course/annotation_evaluation/errors/Genescpace_%j.err

WORKDIR="/data/users/lfernandez/assembly_course"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"

apptainer exec \
    --bind $COURSEDIR  \
    --bind $WORKDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/genespace_latest.sif Rscript $COURSEDIR/scripts/22-Genespace.R $WORKDIR/annotation_evaluation/genespace