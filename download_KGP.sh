#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

BASE_URL="https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502"
PREFIX="ALL.chr"
SUFFIX=".phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz"
CHROMOSOMES=( {1..22} X Y )
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

convert_vcf_to_bed() {
  local vcf="$1"
  local prefix="$2"

  if [[ -f "${prefix}.bed" && -f "${prefix}.bim" && -f "${prefix}.fam" ]]; then
    echo "Skipping existing PLINK files for ${prefix}"
    return
  fi

    echo "Converting ${vcf} to PLINK binary format (bi-allelic only)..."
    plink2 --vcf "${vcf}" --min-alleles 2 --max-alleles 2 --make-bed --out "${prefix}"
}

for chr in "${CHROMOSOMES[@]}"; do
  filename="${PREFIX}${chr}${SUFFIX}"
  indexfile="${filename}.tbi"
  download_file "${BASE_URL}/${filename}" "${filename}"
  download_file "${BASE_URL}/${indexfile}" "${indexfile}"
  convert_vcf_to_bed "${filename}" "chr${chr}"
done

merge_list_file="merge_list.txt"
printf "%s\n" "${CHROMOSOMES[@]:1}" | sed 's/^/chr/' | sed 's/$/.bed/' > "${merge_list_file}"

echo "Merging chromosomes into ${MERGED_PREFIX}..."
plink2 --bfile chr1 --merge-list "${merge_list_file}" --make-bed --out "${MERGED_PREFIX}"

echo "Done. Output files are in: ${PWD}"
