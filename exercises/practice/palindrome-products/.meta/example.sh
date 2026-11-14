#!/usr/bin/env bash

# Search over factor pairs instead of over every possible product.
#
# For "largest": take the first factor a from max downwards and the second
# factor b from a downwards. Products only get smaller, so once a product is
# not bigger than the best palindrome found so far, no later b can beat it,
# and once a * a is smaller than the best, no later a can either.
# "smallest" is the same search in the other direction.

main() {
    local which=$1
    local -i min=$2 max=$3

    (( min > max )) && die "min must be <= max"

    local -i step
    case ${which} in
        smallest) step=1 ;;
        largest)  step=-1 ;;
        *) die "first arg should be 'smallest' or 'largest'" ;;
    esac

    local -i best
    if (( step == 1 )); then
        best=$(smallest_palindrome "${min}" "${max}")
    else
        best=$(largest_palindrome "${min}" "${max}")
    fi

    # best is -1 when the range holds no palindrome product
    (( best < 0 )) && return

    local found
    found=$(factors "${best}" "${min}" "${max}" "${step}")
    printf "%d:%s\n" "${best}" "${found}"
}

# Print the smallest palindrome that is a product of two numbers in min..max,
# or -1 if there is none.
smallest_palindrome() {
    local -i min=$1 max=$2 a b product best=-1
    for ((a = min; a <= max; a++)); do
        (( best >= 0 && a * a > best )) && break
        for ((b = a; b <= max; b++)); do
            product=$(( a * b ))
            (( best >= 0 && product >= best )) && break
            (( product % 10 == 0 )) && continue   # a palindrome cannot end in 0
            if is_palindrome "${product}"; then
                best=${product}
                break
            fi
        done
    done
    echo "${best}"
}

# Print the largest palindrome that is a product of two numbers in min..max,
# or -1 if there is none.
largest_palindrome() {
    local -i min=$1 max=$2 a b product best=-1
    for ((a = max; a >= min; a--)); do
        (( a * a < best )) && break
        for ((b = a; b >= min; b--)); do
            product=$(( a * b ))
            (( product <= best )) && break
            if is_palindrome "${product}"; then
                best=${product}
                break
            fi
        done
    done
    echo "${best}"
}

# Print every factor pair of n within min..max as " [a, b]".
factors() {
    local -i n=$1 min=$2 max=$3 step=$4 i j
    local pairs=""
    if (( step == 1 )); then
        for ((i = min; i * i <= n; i++)); do
            j=$(( n / i ))
            if (( i * j == n && j >= min && j <= max )); then
                pairs+=" [${i}, ${j}]"
            fi
        done
    else
        for ((i = max; i * i >= n; i--)); do
            j=$(( n / i ))
            if (( i * j == n && j >= min && j <= max )); then
                pairs+=" [${j}, ${i}]"
            fi
        done
    fi
    echo "${pairs}"
}

die() {
    echo "$*" >&2
    exit 1
}

is_palindrome() {
    local word=$1
    local -i i j len=${#word}
    for ((i = len / 2; i >= 0; i--)); do
        j=$(( len - i - 1 ))
        [[ ${word:i:1} == "${word:j:1}" ]] || return 1
    done
}

main "$@"
