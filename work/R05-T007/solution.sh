#!/usr/bin/env bash

die() {
    echo "Error: invalid input"
    exit 1
}

# Grains on one square: square n holds 2^(n-1) grains.
grains_on_square() {
    local -i square=$1
    printf '%u\n' $(( 1 << (square - 1) ))
}

# Grains on the whole board: add up all 64 squares.
total_grains() {
    local -i square total=0
    for (( square = 1; square <= 64; square++ )); do
        (( total += 1 << (square - 1) ))
    done
    printf '%u\n' "${total}"
}

main() {
    if [[ $1 == total ]]; then
        total_grains
    elif [[ $1 =~ ^[0-9]+$ ]] && (( 10#$1 >= 1 && 10#$1 <= 64 )); then
        grains_on_square "$((10#$1))"
    else
        die
    fi
}

main "$@"
