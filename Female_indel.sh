#!/bin/sh

WD=/home/lbui/Volvox_WGS_results/Sequences/Female
GENOME=Vcarteri_v2_PseudoFemale_3-13-15.fa
PICARD="/home/lbui/genome_analysis/picard-tools-1.131/picard.jar"
BAM_FILE=/home/lbui/Volvox_WGS_results/Sequences/Female/*.sorted.dedup.bam
GATK="/home/lbui/genome_analysis/GATK/GenomeAnalysisTK.jar"

echo "sequence indexing"
samtools faidx $GENOME
java -jar $PICARD CreateSequenceDictionary \
      R= $GENOME \
      O= $GENOME .dict 

echo "Creating a target list of intervals to be realigned...."

for FQ in *.sorted.dedup.bam
do
samtools index $FQ 

java -jar $GATK \
-T RealignerTargetCreator \
-R $GENOME \
-I $BAM_FILE \
-o "${BAM%.bam}_target_intervals.list"

echo "local realignment..."

java -jar $GATK \
-T IndelRealigner \
-R $GENOME \
-I $BAM_FILE \
-targetIntervals "${BAM%.bam}_target_intervals.list" \
-o "${BAM%.bam}_realigned_reads.bam"

echo "indexing the realigned bam file..."

samtools index "${BAM%.bam}_realigned_reads.bam"

done
echo "Job complete"
