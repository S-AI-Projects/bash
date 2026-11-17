#!/usr/bin/env bash
# MUTANT 2: Invert row-count check — change "!= 0" to "== 0"
# Errors on VALID row counts, accepts INVALID ones.

if [[ -t 0 ]]; then
    lines=()
else
    readarray -t lines
fi

if (( ${#lines[@]} % 4 == 0 )); then
    echo "Number of input lines is not a multiple of four" >&2
    exit 1
fi

if (( ${#lines[0]} % 3 != 0 )); then
    echo "Number of input columns is not a multiple of three" >&2
    exit 1
fi

declare -A map=(
    [" _ | ||_|   "]=0
    ["     |  |   "]=1
    [" _  _||_    "]=2
    [" _  _| _|   "]=3
    ["   |_|  |   "]=4
    [" _ |_  _|   "]=5
    [" _ |_ |_|   "]=6
    [" _   |  |   "]=7
    [" _ |_||_|   "]=8
    [" _ |_| _|   "]=9
)

output=""
separator=","

for (( i = 0; i < ${#lines[@]} / 4; i++ )); do
    (( i > 0 )) && output+=$separator

    for (( j = 0; j < ${#lines[0]}; j += 3 )); do
        ocr_digit=""
        for k in {0..3}; do
            ocr_digit+=${lines[i * 4 + k]:j:3}
        done
        output+=${map[$ocr_digit]:-"?"}
    done

done

echo "$output"
