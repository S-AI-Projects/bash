#!/usr/bin/env bash
# One pass with tr; validate first so a bad strand prints only the error.
dna=$1
if [[ $dna == *[!ACGT]* ]]; then
    echo "Invalid nucleotide detected."
    exit 1
fi
tr 'GCTA' 'CGAU' <<< "$dna"
