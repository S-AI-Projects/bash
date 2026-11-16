#!/usr/bin/env bash

set -euo pipefail

declare -A COLOR_DIGITS=(
    [black]=0 [brown]=1 [red]=2 [orange]=3 [yellow]=4
    [green]=5 [blue]=6 [violet]=7 [grey]=8 [gray]=8 [white]=9
)

declare -A TOLERANCES=(
    [grey]="±0.05%" [gray]="±0.05%" [violet]="±0.1%" [blue]="±0.25%"
    [green]="±0.5%" [brown]="±1%" [red]="±2%" [gold]="±5%" [silver]="±10%"
)

format_ohms() {
    local -i r=$1
    local unit div
    local -i rem int_part
    local frac

    if (( r >= 1000000000 )); then
        unit="gigaohms"
        div=1000000000
    elif (( r >= 1000000 )); then
        unit="megaohms"
        div=1000000
    elif (( r >= 1000 )); then
        unit="kiloohms"
        div=1000
    else
        unit="ohms"
        div=1
    fi

    int_part=$(( r / div ))
    rem=$(( r % div ))

    if (( rem == 0 )); then
        echo "${int_part} ${unit}"
    else
        if (( div == 1000000 )); then
            frac=$(printf "%06d" "$rem")
        elif (( div == 1000 )); then
            frac=$(printf "%03d" "$rem")
        else
            frac=$(printf "%09d" "$rem")
        fi
        while [[ ${frac: -1} == "0" ]]; do
            frac=${frac%0}
        done
        echo "${int_part}.${frac} ${unit}"
    fi
}

main() {
    local colors=( "$@" )
    local tolerance=""
    local -i ohms=0

    case ${#colors[@]} in
        1)
            [[ ${colors[0]} == "black" ]] || { echo "invalid color" >&2; exit 1; }
            echo "0 ohms"
            return 0
            ;;
        4)
            local d1=${COLOR_DIGITS[${colors[0]}]}
            local d2=${COLOR_DIGITS[${colors[1]}]}
            local mult=${COLOR_DIGITS[${colors[2]}]}
            tolerance=${TOLERANCES[${colors[3]}]}
            local digits="${d1}${d2}"
            ohms=$(( 10#${digits} * 10 ** mult ))
            ;;
        5)
            local d1=${COLOR_DIGITS[${colors[0]}]}
            local d2=${COLOR_DIGITS[${colors[1]}]}
            local d3=${COLOR_DIGITS[${colors[2]}]}
            local mult=${COLOR_DIGITS[${colors[3]}]}
            tolerance=${TOLERANCES[${colors[4]}]}
            local digits="${d1}${d2}${d3}"
            ohms=$(( 10#${digits} * 10 ** mult ))
            ;;
        *)
            echo "invalid band count" >&2
            exit 1
            ;;
    esac

    local val_unit
    val_unit=$(format_ohms "$ohms")
    if [[ -n "$tolerance" ]]; then
        echo "${val_unit} ${tolerance}"
    else
        echo "${val_unit}"
    fi
}

main "$@"
