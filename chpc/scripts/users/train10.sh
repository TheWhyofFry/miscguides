#!/bin/bash
#PBS -l select=1:ncpus=24:mpiprocs=24:nodetype=haswell_reg
#PBS -P CBBI0905
#PBS -q smp
#PBS -l walltime=1:00:00
#PBS -o /home/wsmidt/output/train10.out
#PBS -e /home/wsmidt/output/train10.err

#PBS -N trainingmap_train10
#PBS -M wambuisara@gmail.com

mkdir -p /home/wsmidt/lustre/chpc_lecture/train10

module add chpc/BIOMODULES
module load bcftools
module load bowtie2
module load samtools

cd mkdir -p /home/wsmidt/lustre/chpc_lecture/train10

 bowtie2 -p 24 -x k12_index_file -1 reads1.fastq.gz -2 reads2.fastq.gz -S k12map.sam
 samtools view -but referencegenome.fasta k12map.sam > k12map.bam
 samtools sort k12map.bam k12map.sorted.bam
 samtools mpileup -uf k12.fasta ./k12map.sorted.bam > k12map.sorted.mpileup
 bcftools call --output-type v --ploidy 1 -v -m -V indels k12map.sorted.mpileup > k12.vcf 

