# README

## 1. Data sources

This task is based on publicly available sequencing data from the study "Bulk RNA sequencing reveals the comprehensive genetic characteristics of human cord blood-derived natural killer cells". The dataset compares Cord Blood-derived Natural Killer Cells (CBNKCs) with Peripheral Blood-derived Natural Killer Cells (PBNKCs). The dataset was originally sequenced using **\[Illumina NovaSeq 6000]**.

The subsampled and cleaned FASTQs are stored in `data/` and are used as the inputs for the workflow.

---

## 2. How to download

Data acquired from SRA

```bash
cd nk_cells/data
./download.sh
```

---

## 3. Pre-processing / subsampling

Filter down to only 25% of reads

```bash
cd nk_cells/data
./subsample.sh
```

---

## 4. How the workflow works

The workflow files is stored in `workflow/`.

---

### Step 1 – Re-run nextflow workflow described in article

**Purpose:** Remove low-quality reads and adapter sequences, align to a reference and generate a count matrix

**Tools:** `nextflow`, `fastqc`, `star`, `featureCounts`

**Inputs:** Subsampled FASTQ files (from`data/sra_data_downsampled/`), references (from `data/reference_files/`)

**Outputs:** QC reports, Alignments, Count Matrix

**Command:**

```bash
bash workflow/run_rnaseq.sh
Rscript workflow/gather_counts.R results/featureCounts/*txt
```

---

### Step 2 - Perform differential expression analysis

**Purpose:** Find differentially expressed genes between the conditions

**Tools:** `R`, `DESeq2`, `Clusterprofiler`

**Inputs:** Count Matrix, metadata table

**Outputs:** Table of differentially expressed genes

**Command:**

```bash
quarto render workflow/run_dge.qmd
```
