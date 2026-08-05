#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

BASE_URL="https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502"
PREFIX="ALL.chr"
SUFFIX=".phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz"
CHROMOSOMES=( {1..22} )
OUTDIR="kgp"
MERGED_PREFIX="KGP_merged"

mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

if ! command -v plink2 >/dev/null 2>&1; then
  echo "ERROR: plink2 is not installed or not on PATH." >&2
  exit 1
fi

download_file() {
  local url="$1"
  local target="$2"

  if [[ -s "${target}" ]]; then
    echo "Skipping existing file: ${target}"
    return
  fi

  echo "Downloading ${target}..."
  wget --continue --tries=5 --timeout=30 --retry-connrefused --waitretry=5 --progress=dot:giga "${url}" -O "${target}"
}

convert_vcf_to_pgen() {
  local vcf="$1"
  local prefix="$2"

  if [[ -f "${prefix}.pgen" && -f "${prefix}.pvar" && -f "${prefix}.psam" ]]; then
    echo "Skipping existing PLINK files for ${prefix}"
    return
  fi

    echo "Converting ${vcf} to PLINK binary format (bi-allelic only)..."
    plink2 --vcf "${vcf}" --min-alleles 2 --max-alleles 2 --make-pgen --out "${prefix}"
}

for chr in "${CHROMOSOMES[@]}"; do
  filename="${PREFIX}${chr}${SUFFIX}"
  indexfile="${filename}.tbi"
  download_file "${BASE_URL}/${filename}" "${filename}"
  download_file "${BASE_URL}/${indexfile}" "${indexfile}"
  convert_vcf_to_pgen "${filename}" "chr${chr}"
done

merge_list_file="kgp/merge_list.txt" > "${merge_list_file}"
for chr in "${CHROMOSOMES[@]}"; do
  echo "chr${chr}" >> "${merge_list_file}"
done

echo "Merging chromosomes into ${MERGED_PREFIX}..."
plink2 --pmerge-list "${merge_list_file}" --make-bed --out "${MERGED_PREFIX}" --set-all-var-ids @:#:\$r:\$a --new-id-max-allele-len 1000

echo "Downloading integrated panel data"
download_file "https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel" "integrated_call_samples_v3.20130502.ALL.panel"

echo "Computing Principal components (PCA) on merged data..."
plink2 \
    --pfile "${MERGED_PREFIX}" \
    --indep-pairwise 1000 50 0.05

plink2 \
    --pfile "${MERGED_PREFIX}" \
    --extract plink2.prune.in \
    --maf 0.01 \
    --make-pgen \
    --out "${MERGED_PREFIX}.pruned" \
    --exclude range ../assets/exclude_b37.tsv

plink2 --pfile "${MERGED_PREFIX}.pruned" --pca 20 --out "${MERGED_PREFIX}_pca"

echo "Done. Output files are in: ${PWD}"
