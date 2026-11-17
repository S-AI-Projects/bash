#!/usr/bin/env bash

main() {
  local -i n="${1}"
  local -a factors=()

  while (( n % 2 == 0 )); do
    factors+=( 2 )
    (( n /= 2 ))
  done

  local -i p=3
  while (( p * p <= n )); do
    if (( n % p == 0 )); then
      factors+=( "${p}" )
      (( n /= p ))
    else
      (( p += 2 ))
    fi
  done

  (( n > 1 )) && factors+=( "${n}" )

  echo "${factors[*]}"
}

main "$@"
