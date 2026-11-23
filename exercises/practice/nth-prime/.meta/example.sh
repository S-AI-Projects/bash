#!/usr/bin/env bash

# Pure Bash implementation of Sieve of Eratosthenes without bc
# Finds the nth prime number efficiently using odd-only indexing.

main() {
    local -i n="$1"
    if (( n <= 0 )); then
        echo "invalid input" >&2
        exit 1
    fi

    local -i upper
    upper=$(approx_nth "${n}")
    local -a primes=()
    sieve "${upper}" primes "${n}"

    echo "${primes[n-1]}"
}

approx_ln() {
    local -i x="$1"
    local -i k=0
    local -i temp="${x}"
    while (( temp > 1 )); do
        (( temp >>= 1 ))
        (( k++ ))
    done
    local -i m=$(( (x * 1000) >> k ))
    local -i frac=$(( (m - 1000) * 2000 / (m + 1000) ))
    echo "$(( k * 693 + frac ))"
}

approx_nth() {
    local -i n="$1"
    if (( n < 6 )); then
        echo 15
        return
    fi
    local -i ln_val
    ln_val=$(approx_ln "${n}")
    echo "$(( 15 + (13 * n * ln_val) / 10000 ))"
}

sieve() {
    local -i limit="$1"
    local -n primes_="$2"
    local -i target_count="$3"

    primes_=(2)
    (( target_count == 1 )) && return

    local -a composite=()
    local -i max_k=$(( limit / 2 ))
    local -i p=0 k=0 i=0

    for (( p = 3; p * p <= limit; p += 2 )); do
        k=$(( p / 2 ))
        if (( ! composite[k] )); then
            for (( i = (p * p) / 2; i <= max_k; i += p )); do
                composite[i]=1
            done
        fi
    done

    for (( k = 1; k <= max_k; k++ )); do
        if (( ! composite[k] )); then
            primes_+=( "$(( 2 * k + 1 ))" )
            if (( ${#primes_[@]} == target_count )); then
                break
            fi
        fi
    done
}

main "$@"
