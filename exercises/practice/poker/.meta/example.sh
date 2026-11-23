#!/usr/bin/env bash

# external tools used: sort, grep, wc, uniq

declare -ri SUCCESS=0
declare -ri FAILURE=1

main() {
    local -A hand_scores=()

    local hand
    for hand in "$@"; do
        validate "${hand}" || die "invalid hand"
        local evaluated_score
        evaluated_score=$(evaluate "${hand}")
        hand_scores["${hand}"]="${evaluated_score}"
    done

    local -i max=-1
    local -i val
    for val in "${hand_scores[@]}"; do
        if (( val > max )); then
            max=${val}
        fi
    done

    for hand in "${!hand_scores[@]}"; do
        if (( max == hand_scores["${hand}"] )); then
            echo "${hand}"
        fi
    done
}

die() {
    echo "$*" >&2
    exit "${FAILURE}"
}

validate() {
    local card="1?[234567890JQKA][HCSD]"
    local re="^${card}( ${card}){4}$"
    [[ $1 =~ ${re} ]]
}

card_value() {
    local face="${1%[HSCD]}"
    case "${face}" in
        A) echo 14 ;;
        K) echo 13 ;;
        Q) echo 12 ;;
        J) echo 11 ;;
        *) echo "${face}" ;;
    esac
}

ranking() {
    local formatted_rank=""
    printf -v formatted_rank "%02d" "$@"
    echo "$(( 10#${formatted_rank} ))"
}

is_5_of_a_kind() {
    has_grouping "5" "$@"
}

is_4_of_a_kind() {
    has_grouping "4 1" "$@"
}

is_3_of_a_kind() {
    has_grouping "3 1 1" "$@"
}

is_full_house() {
    has_grouping "3 2" "$@"
}

is_2_pairs() {
    has_grouping "2 2 1" "$@"
}

is_1_pair() {
    has_grouping "2 1 1 1" "$@"
}

# shellcheck disable=SC2312
is_flush() {
    local cards="$1"
    shift
    local -a card_arr=()
    read -ra card_arr <<< "${cards}"
    local -i num_suits
    num_suits=$(printf "%s\n" "${card_arr[@]}" | grep -o ".$" | sort -u | wc -l)
    if (( num_suits == 1 )); then
        ranking "$@"
        return "${SUCCESS}"
    fi
    return "${FAILURE}"
}

is_straight() {
    if [[ "$*" == "14 5 4 3 2" ]]; then
        ranking 5 4 3 2 1
        return "${SUCCESS}"
    fi

    local -i prev=$1
    local -i idx
    for idx in {2..5}; do
        local -i curr=${!idx}
        (( prev == curr + 1 )) || return "${FAILURE}"
        prev=${curr}
    done
    ranking "$@"
    return "${SUCCESS}"
}

is_straight_flush() {
    local cards="$1"
    shift
    is_flush "${cards}" "$@" >/dev/null && is_straight "$@"
}

# shellcheck disable=SC2312
has_grouping() {
    local groupings="$1"
    shift
    local -a groups=() values=()
    local g="" v=""
    local grouped_output
    grouped_output=$(printf "%s\n" "$@" | sort -nr | uniq -c | sort -k1,1nr -k2,2nr)
    while read -r g v; do
        groups+=("${g}")
        values+=("${v}")
    done <<< "${grouped_output}"

    if [[ "${groups[*]}" == "${groupings}" ]]; then
        ranking "${values[@]}"
        return "${SUCCESS}"
    fi
    return "${FAILURE}"
}

classify_hand_rank() {
    local cards="$1"
    shift
    local -a values=("$@")
    local -i tiebreaker=0

    if tiebreaker=$(is_5_of_a_kind "${values[@]}"); then
        echo "9 ${tiebreaker}"
    elif tiebreaker=$(is_straight_flush "${cards}" "${values[@]}"); then
        echo "8 ${tiebreaker}"
    elif tiebreaker=$(is_4_of_a_kind "${values[@]}"); then
        echo "7 ${tiebreaker}"
    elif tiebreaker=$(is_full_house "${values[@]}"); then
        echo "6 ${tiebreaker}"
    elif tiebreaker=$(is_flush "${cards}" "${values[@]}"); then
        echo "5 ${tiebreaker}"
    elif tiebreaker=$(is_straight "${values[@]}"); then
        echo "4 ${tiebreaker}"
    elif tiebreaker=$(is_3_of_a_kind "${values[@]}"); then
        echo "3 ${tiebreaker}"
    elif tiebreaker=$(is_2_pairs "${values[@]}"); then
        echo "2 ${tiebreaker}"
    elif tiebreaker=$(is_1_pair "${values[@]}"); then
        echo "1 ${tiebreaker}"
    else
        tiebreaker=$(ranking "${values[@]}")
        echo "0 ${tiebreaker}"
    fi
}

# shellcheck disable=SC2312
evaluate() {
    local cards="$1"

    local -a card_arr=()
    read -ra card_arr <<< "${cards}"
    local -a values=()
    local card
    local card_vals
    card_vals=$(
        for card in "${card_arr[@]}"; do
            card_value "${card}"
        done | sort -nr
    )
    readarray -t values <<< "${card_vals}"

    local classification
    classification=$(classify_hand_rank "${cards}" "${values[@]}")
    local -i hand_rank=0 tiebreaker=0
    read -r hand_rank tiebreaker <<< "${classification}"

    echo "$(( hand_rank * 10**11 + tiebreaker ))"
}

main "$@"
