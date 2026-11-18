#!/usr/bin/env bash

main() {
  # Replace hyphens with spaces (hyphens are word separators)
  local phrase="${1//-/ }"

  # Remove punctuation other than apostrophes and whitespace
  # Underscores are punctuation and must be removed so _Not_ becomes Not
  phrase="${phrase//[_*,\!]/}"

  local acronym=""
  local word
  # Disable pathname expansion (globbing) so '*' or '?' are not expanded
  set -f
  for word in ${phrase}; do
    acronym+="${word:0:1}"
  done
  set +f

  echo "${acronym^^}"
}

main "$@"
