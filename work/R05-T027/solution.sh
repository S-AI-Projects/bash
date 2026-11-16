#!/usr/bin/env bash
set -euo pipefail

code=$1
actions=( "wink" "double blink" "close your eyes" "jump" )
result=()

for (( i = 0; i < ${#actions[@]}; i++ )); do
    if (( (code & (1 << i)) != 0 )); then
        result+=( "${actions[i]}" )
    fi
done

if (( code & 16 )); then
    reversed=()
    for (( i = ${#result[@]} - 1; i >= 0; i-- )); do
        reversed+=( "${result[i]}" )
    done
    result=( "${reversed[@]}" )
fi

IFS=,
echo "${result[*]}"
