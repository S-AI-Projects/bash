#!/usr/bin/env bash

main() {
    declare -A scores
    local group score letters letter
    local -a letter_array

    for group in "$@"; do
        score="${group%%:*}"
        letters="${group#*:}"
        IFS=',' read -r -a letter_array <<< "$letters"
        for letter in "${letter_array[@]}"; do
            scores["${letter,,}"]="$score"
        done
    done

    for letter in $(printf '%s\n' "${!scores[@]}" | LC_ALL=C sort); do
        echo "$letter: ${scores[$letter]}"
    done
}

main "$@"
