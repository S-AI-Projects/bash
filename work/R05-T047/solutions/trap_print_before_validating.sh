#!/usr/bin/env bash
# TRAP 2 (must fail): prints translated letters before it finds the invalid one.
dna=$1
for (( i = 0; i < ${#dna}; i++ )); do
    case ${dna:i:1} in
        G) printf C ;; C) printf G ;; T) printf A ;; A) printf U ;;
        *) echo; echo "Invalid nucleotide detected."; exit 1 ;;
    esac
done
echo
