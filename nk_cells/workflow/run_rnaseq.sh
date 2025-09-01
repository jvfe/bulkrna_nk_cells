#!/usr/bin/bash
set -e

# Run the pipeline with adjusted paths
nextflow run workflow/simplernaseq \
    --input data/samplesheet.csv \
    --fasta data/reference_files/hg38.fa.gz \
    --gtf data/reference_files/hg38.refGene.gtf.gz \
    --outdir results \
    -profile docker \
    -resume
