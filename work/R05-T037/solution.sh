#!/usr/bin/env bash
#
# Verify whether a given string is a valid ISBN-10 number.

set -o errexit
set -o nounset

#######################################
# Validate an ISBN-10 string.
# Arguments:
#   Input candidate string
# Outputs:
#   "true" if valid ISBN-10, "false" otherwise
#######################################
main() {
  local input="${1:-}"
  local isbn="${input//-/}"
  local -i sum=0 weight=10
  local -i i val

  # The ISBN must consist of exactly 9 digits followed by 1 digit or 'X'.
  if ! [[ "${isbn}" =~ ^[0-9]{9}[0-9X]$ ]]; then
    echo "false"
    return 0
  fi

  for (( i = 0; i < 9; i++ )); do
    val="${isbn:i:1}"
    (( sum += val * weight ))
    (( weight-- ))
  done

  if [[ "${isbn:9:1}" == "X" ]]; then
    (( sum += 10 ))
  else
    val="${isbn:9:1}"
    (( sum += val ))
  fi

  if (( sum % 11 == 0 )); then
    echo "true"
  else
    echo "false"
  fi
}

main "${@}"
