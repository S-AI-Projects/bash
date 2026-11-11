#!/usr/bin/env bash

# this requires bash 4.3+ for the use of namerefs

main() {
    local -i amount=$1
    shift
    # shellcheck disable=SC2034
    local -a denominations=( "$@" )
    # shellcheck disable=SC2034
    local -a first_coin_for_value=()

    if (( amount < 0 )); then
        echo "target can't be negative" >&2
        exit 1
    fi
    (( amount == 0 )) && exit 0

    change "${amount}" denominations first_coin_for_value
    make_change "${amount}" denominations first_coin_for_value
}

change() {
    local -i amount=$1
    local -n coins=$2
    # shellcheck disable=SC2178
    local -n S=$3
    local -a C
    local -i max=99999999
    local i p min coin

    C=(0)
    S=(0)
    for ((i = 1; i <= amount; i++)); do
        C+=( "${max}" )
        S+=( "" )
    done

    for ((p = 1; p <= amount; p++)); do
        min=${max}
        coin=""
        for ((i = 0; i < ${#coins[@]}; i++)); do
            if (( coins[i] <= p && 1 + C[p - coins[i]] < min )); then
                min=$((1 + C[p - coins[i]]))
                coin=${i}
            fi
        done
        C[p]=${min}
        S[p]=${coin}
    done
}

make_change() {
    local -i amount=$1
    local -n coins=$2
    # shellcheck disable=SC2178
    local -n S=$3
    local -a change=()
    local coin idx

    if [[ -z ${S[amount]} ]]; then
        echo "can't make target with given coins" >&2
        exit 1
    fi

    while (( amount > 0 )); do
        idx=${S[amount]}
        coin=${coins[idx]}
        change+=( "${coin}" )
        ((amount -= coin))
    done

    # shellcheck disable=SC2312
    printf "%d\n" "${change[@]}" | sort -n | paste -sd" "
}

main "$@"
