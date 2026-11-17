#!/usr/bin/env bash
# MUTANT 3: Remove row-count check entirely
# Never rejects input for having wrong number of lines.

if [[ -t 0 ]]; then
    lines=()
else
    readarray -t lines
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
