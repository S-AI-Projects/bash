#!/usr/bin/env bash
# shellcheck disable=SC2310 # Predicate functions intentionally return nonzero for false comparisons; failures are handled explicitly.
#
# Classifies a triangle based on its three side lengths.

set -o errexit
set -o nounset
set -o pipefail

# Evaluates a numerical comparison using bc.
assert() {
  local expression="${1}"
  local result

  result=$(bc -l <<< "${expression}") || return 1
  [[ "${result}" -eq 1 ]] || return 1
}

# Prints the classification result and exits successfully.
output() {
  local exit_code="${1}"

  if [[ "${exit_code}" -eq 0 ]]; then
    printf 'true\n'
  else
    printf 'false\n'
  fi

  exit 0
}

# Checks whether three sides form a valid triangle.
valid_triangle() {
  local side1="${1}"
  local side2="${2}"
  local side3="${3}"

  if assert "${side1} == 0" ||
    assert "${side2} == 0" ||
    assert "${side3} == 0"; then
    return 1
  fi

  if assert "${side1} + ${side2} <= ${side3}" ||
    assert "${side1} + ${side3} <= ${side2}" ||
    assert "${side2} + ${side3} <= ${side1}"; then
    return 1
  fi

  return 0
}

# Checks whether all three sides are equal.
equilateral() {
  if assert "${1} == ${2}" && assert "${1} == ${3}"; then
    output 0
  else
    output 1
  fi
}

# Checks whether at least two sides are equal.
isosceles() {
  if assert "${1} == ${2}" ||
    assert "${1} == ${3}" ||
    assert "${2} == ${3}"; then
    output 0
  else
    output 1
  fi
}

# Checks whether all three sides are different.
scalene() {
  if assert "${1} != ${2}" &&
    assert "${1} != ${3}" &&
    assert "${2} != ${3}"; then
    output 0
  else
    output 1
  fi
}

# Validates the arguments and runs the requested classification.
main() {
  if [[ $# -ne 4 ]]; then
    printf 'Usage: %s [equilateral | isosceles | scalene] <s1> <s2> <s3>\n' "$0"
    exit 2
  fi

  local triangle_type="${1}"
  local s1="${2}"
  local s2="${3}"
  local s3="${4}"

  if ! valid_triangle "${s1}" "${s2}" "${s3}"; then
    output 1
  fi

  case "${triangle_type}" in
    equilateral | isosceles | scalene)
      "${triangle_type}" "${s1}" "${s2}" "${s3}"
      ;;
    *)
      exit 1
      ;;
  esac
}

main "$@"
