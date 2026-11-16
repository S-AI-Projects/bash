#!/usr/bin/env bash
#
# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

set -o errexit
set -o nounset

#######################################
# Find all prime numbers up to a given limit using the Sieve of Eratosthenes.
# Arguments:
#   Limit integer
# Outputs:
#   Space-separated list of prime numbers
#######################################
main() {
  local -i limit="${1:-0}"
  local -a is_composite=()
  local -a primes=()
  local -i p m

  # Sieve odd composite numbers starting from 3 up to sqrt(limit)
  for (( p = 3; p * p <= limit; p += 2 )); do
    if (( !is_composite[p] )); then
      for (( m = p * p; m <= limit; m += 2 * p )); do
        is_composite[m]=1
      done
    fi
  done

  # 2 is the only even prime
  if (( limit >= 2 )); then
    primes+=(2)
  fi

  # Collect odd primes up to limit
  for (( p = 3; p <= limit; p += 2 )); do
    if (( !is_composite[p] )); then
      primes+=("${p}")
    fi
  done

  echo "${primes[*]}"
}

main "${@}"
