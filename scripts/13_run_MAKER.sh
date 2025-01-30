#!/usr/bin/env bash

#SBATCH --ntasks-per-node=50
#SBATCH --mem=64G
#SBATCH --time=5-00:00:00
#SBATCH --job-name=13_MAKER
#SBATCH --error=/data/users/lfernandez/assembly_course/MAKER_annotation/errors/MAKER_%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/MAKER_annotation/jobs/MAKER_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8


COURSEDIR=/data/courses/assembly-annotation-course/CDS_annotation
MAKERDIR=/data/users/lfernandez/assembly_course/MAKER_annotation
WORKDIR=/data/users/lfernandez/assembly_course
CONTAINER_DIR=/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif

cd $MAKERDIR

REPEATMASKER_DIR=/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker
export PATH=$PATH:"/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"

module load OpenMPI/4.1.1-GCC-10.3.0
module load AUGUSTUS/3.4.0-foss-2021a

mpiexec --oversubscribe -n 50 apptainer exec\
 --bind $SCRATCH:/TMP --bind $COURSEDIR --bind $AUGUSTUS_CONFIG_PATH --bind $REPEATMASKER_DIR\
 $CONTAINER_DIR\
 maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl