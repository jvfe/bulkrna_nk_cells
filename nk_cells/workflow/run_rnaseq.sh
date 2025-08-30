#!/usr/bin/bash
set -e

# Run the pipeline with adjusted paths
nextflow run workflow/simplernaseq \
    --input data/samplesheet.csv \
    --fasta data/reference_files/Homo_sapiens.GRCh38.chr22.fa \
    --gtf data/reference_files/Homo_sapiens.GRCh38.112.chr22.gtf \
    --outdir results \
    -profile docker \
    -resume
