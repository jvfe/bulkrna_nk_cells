#!/bin/bash

set -e

FASTA_URL="http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz"
GTF_URL="http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.refGene.gtf.gz"

OUTPUT_DIR="reference_files"
FASTA_FULL="hg38.fa"
GTF_FULL="hg38.refGene.gtf"
FASTA_SUBSET="hg38.chr1-3_12.fa.gz"
GTF_SUBSET="hg38.refGene.chr1-3_12.gtf.gz"

echo "--- Setting up directory: ${OUTPUT_DIR} ---"
mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

echo "--- Checking and downloading files ---"
if [ ! -f "hg38.fa.gz" ]; then
    echo "Downloading FASTA file (hg38.fa.gz)..."
    wget -c -O "hg38.fa.gz" "$FASTA_URL"
else
    echo "FASTA file already downloaded."
fi

if [ ! -f "hg38.refGene.gtf.gz" ]; then
    echo "Downloading GTF file (hg38.refGene.gtf.gz)..."
    wget -c -O "hg38.refGene.gtf.gz" "$GTF_URL"
else
    echo "GTF file already downloaded."
fi

echo "--- Decompressing files (if necessary) ---"
if [ ! -f "$FASTA_FULL" ]; then
    echo "Decompressing FASTA..."
    gunzip -c "hg38.fa.gz" > "$FASTA_FULL"
else
    echo "FASTA file already decompressed."
fi

if [ ! -f "$GTF_FULL" ]; then
    echo "Decompressing GTF..."
    gunzip -c "hg38.refGene.gtf.gz" > "$GTF_FULL"
else
    echo "GTF file already decompressed."
fi

echo "--- Subsetting and compressing GTF file for chromosomes 1, 2, 3, and 12 ---"
awk -F'\t' 'BEGIN{OFS="\t"} $1 == "chr1" || $1 == "chr2" || $1 == "chr3" || $1 == "chr12"' "$GTF_FULL" | gzip > "$GTF_SUBSET"
echo "Subset GTF saved to: ${GTF_SUBSET}"

echo "--- Subsetting and compressing FASTA file for chromosomes 1, 2, 3, and 12 (using awk)... ---"
awk '/^>chr/ {if ($1 == ">chr1" || $1 == ">chr2" || $1 == ">chr3" || $1 == ">chr12") {p=1} else {p=0}} p' "$FASTA_FULL" | gzip > "$FASTA_SUBSET"
echo "Subset FASTA saved to: ${FASTA_SUBSET}"

echo "--- Cleaning up large intermediate files... ---"
rm "$FASTA_FULL" "$GTF_FULL"

echo "--- Script finished successfully! ---"
echo "Your compressed subset files are in the '${OUTPUT_DIR}' directory."
echo "Downloaded archives can be found at '${OUTPUT_DIR}/hg38.fa.gz' and '${OUTPUT_DIR}/hg38.refGene.gtf.gz'"

