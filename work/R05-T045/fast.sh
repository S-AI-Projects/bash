#!/usr/bin/env bash

declare -ir perimeter=$1
declare -i a b c numerator denominator

for (( a = 3; a < perimeter / 3; a++ )); do
    numerator=$(( perimeter * (perimeter - 2 * a) ))
    denominator=$(( 2 * (perimeter - a) ))

    if (( numerator % denominator != 0 )); then
        continue
    fi

    b=$(( numerator / denominator ))
    c=$(( perimeter - a - b ))

    if (( a < b && b < c )); then
        if (( a * a + b * b == c * c )); then
            echo "${a},${b},${c}"
        fi
    fi
done
