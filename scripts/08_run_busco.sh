#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=64GB
#SBATCH --time=1-00:00:00
#SBATCH --job-name=08_run_busco
#SBATCH --error=/data/users/lfernandez/assembly_course/assembly_evaluation/errors/busco%j.e
#SBATCH --output=/data/users/lfernandez/assembly_course/assembly_evaluation/jobs/busco_%j.o
#SBATCH --mail-user=laura.fernandez@students.unibe.ch
#SBATCH --partition=pibu_el8

CONTAINER_DIR=/containers/apptainer
WORK_DIR=/data/users/lfernandez/assembly_course
OUT_DIR=/data/users/lfernandez/assembly_course/assembly_evaluation/busco
PLOT_DIR=/data/users/lfernandez/assembly_course/assembly_evaluation/busco/plots



mkdir -p $OUT_DIR
mkdir -p $PLOT_DIR

#For flye assembly
module load BUSCO/5.4.2-foss-2021a 
busco -i $WORK_DIR/assembly/flye/assembly.fasta -m genome -l brassicales_odb10 --cpu 16 -o $OUT_DIR/busco_flye -f

#For hifiasm assembly
busco -i $WORK_DIR/assembly/hifiasm/ERR11437308.asm.bp.p_ctg.fa -m genome -l brassicales_odb10 --cpu 16 -o $OUT_DIR/busco_hifiasm -f

#For lja assembly
busco -i $WORK_DIR/assembly/lja/assembly.fasta -m genome -l brassicales_odb10 --cpu 16 -o $OUT_DIR/busco_lja -f

#For trinity
busco -i $WORK_DIR/assembly/trinity/trinity.Trinity.fasta -m  transcriptome -l brassicales_odb10 --cpu 16 -o $OUT_DIR/busco_trinity -f

#BUSCO plots

## create busco plot
# copy the busco short_summary files to the plot folder
cp /data/users/lfernandez/assembly_course/assembly_evaluation/busco/busco_flye/short_summary.specific.brassicales_odb10.busco_flye.txt $PLOT_DIR/.
cp /data/users/lfernandez/assembly_course/assembly_evaluation/busco/busco_hifiasm/short_summary.specific.brassicales_odb10.busco_hifiasm.txt $PLOT_DIR/.
cp /data/users/lfernandez/assembly_course/assembly_evaluation/busco/busco_lja/short_summary.specific.brassicales_odb10.busco_lja.txt $PLOT_DIR/.
cp /data/users/lfernandez/assembly_course/assembly_evaluation/busco/busco_trinity/short_summary.specific.brassicales_odb10.busco_trinity.txt $PLOT_DIR/.

# move to the plot directory and download the generate_plot.py script from the BUSCO GitHub
cd $PLOT_DIR
wget https://gitlab.com/ezlab/busco/-/raw/master/scripts/generate_plot.py

python3 generate_plot.py -wd $PLOT_DIR