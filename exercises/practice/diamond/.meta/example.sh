#!/usr/bin/env bash

# Print an error message and exit with failure.
error() {
  printf '%s\n' 'Invalid input'
  exit 1
}

# Validate command-line arguments.
check_args() {
  [[ $# -ne 1 || -z "${1}" || ${#1} -ne 1 || "${1}" != "${1//[![:upper:]]/}" ]] && error
}

# Print the given number of spaces.
pad() {
  local -r padding="${1}"

  local -i x=1
  while (( x <= padding )); do
    printf '%s' ' '
    (( x++ ))
  done
}

# Print the first or last line containing 'A'.
line_a() {
  local -r padding=$(( line_width / 2 ))
  pad "${padding}"
  printf '%s' 'A'
  pad "${padding}"
  printf '\n'
}

# Print lines from level 2 up to max_level.
up_to_max() {
  local -i level=2
  local -i int_padding=1
  local -i ext_padding=$(( line_width / 2 - 1 ))
  local letter

  while (( level <= max_level )); do
    letter="${from_idx_map[${level}]}"
    pad "${ext_padding}"
    printf '%s' "${letter}"
    pad "${int_padding}"
    printf '%s' "${letter}"
    pad "${ext_padding}"
    printf '\n'
    (( level++ ))
    (( ext_padding-- ))
    (( int_padding += 2 ))
  done
}

# Print lines from max_level - 1 down to level 2.
down_to_last() {
  local -i level=$(( max_level - 1 ))
  local -i ext_padding=1
  local -i int_padding=$(( line_width - 4 ))
  local letter

  while (( level >= 2 )); do
    letter="${from_idx_map[${level}]}"
    pad "${ext_padding}"
    printf '%s' "${letter}"
    pad "${int_padding}"
    printf '%s' "${letter}"
    pad "${ext_padding}"
    printf '\n'
    (( level-- ))
    (( ext_padding++ ))
    (( int_padding -= 2 ))
  done
}

main() {
  check_args "$@"

  local -r letter="${1}"

  # In order not to print two A's
  if [[ "${letter}" == 'A' ]]; then
    printf '%s\n' 'A'
    exit 0
  fi

  # Make the maps
  declare -A to_idx_map from_idx_map

  local -i i=1
  local ch
  for ch in {A..Z}; do
    to_idx_map[${ch}]=${i}
    from_idx_map[${i}]="${ch}"
    (( i++ ))
  done

  # Set initial variables for process
  readonly max_level=${to_idx_map[${letter}]}
  readonly line_width=$(( max_level * 2 - 1 ))

  line_a
  up_to_max
  down_to_last
  line_a
}

main "$@"
