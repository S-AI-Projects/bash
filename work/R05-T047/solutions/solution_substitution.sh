#!/usr/bin/env bash
# Parameter expansion only; mark each letter with a placeholder so a later
# replacement cannot undo an earlier one.
dna=$1
if [[ $dna == *[!ACGT]* ]]; then
    echo "Invalid nucleotide detected."
    exit 1
fi
rna=${dna//G/c}
rna=${rna//C/g}
rna=${rna//T/a}
rna=${rna//A/u}
echo "${rna^^}"
