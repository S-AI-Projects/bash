#!/usr/bin/env bash
# TRAP 1 (must fail): plain chained substitutions, each one sees the previous result.
dna=$1
[[ $dna == *[!ACGT]* ]] && { echo "Invalid nucleotide detected."; exit 1; }
dna=${dna//G/C}; dna=${dna//C/G}; dna=${dna//T/A}; dna=${dna//A/U}
echo "$dna"
