#!/usr/bin/env bash
# run_mutants.sh — Mutation testing for ocr-numbers exercise
# Runs the existing test suite against each mutant to find survivors.
#
# Usage: bash work/R05-T053/run_mutants.sh
# Must be run from the repository root.

set -euo pipefail

readonly REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
readonly EXERCISE_DIR="${REPO_ROOT}/exercises/practice/ocr-numbers"
readonly MUTANT_DIR="${REPO_ROOT}/work/R05-T053"
readonly SOLUTION="ocr_numbers.sh"

# Descriptions of each mutant
declare -A descriptions=(
  [mutant1]="Weaken row-count check: % 4 -> % 2"
  [mutant2]="Invert row-count check: != 0 -> == 0"
  [mutant3]="Remove row-count check entirely"
  [mutant4]="Invert column-count check: != 0 -> == 0"
  [mutant5]="Remove column-count check entirely"
  [mutant6]="Change row error exit code: exit 1 -> exit 0"
  [mutant7]="Remove '?' fallback for unrecognized digits"
)

survived=0
killed=0
total=0

printf '=%.0s' {1..60}
printf '\n  Mutation Testing: ocr-numbers\n'
printf '=%.0s' {1..60}
printf '\n\n'

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Copy exercise files to temp directory
cp "${EXERCISE_DIR}/"*.bats "${tmpdir}/"
cp "${EXERCISE_DIR}/bats-extra.bash" "${tmpdir}/"

for mutant_file in "${MUTANT_DIR}"/mutant*.sh; do
  mutant_name=$(basename "$mutant_file" .sh)
  total=$(( total + 1 ))

  printf '[%d] %-8s  %s\n' "$total" "$mutant_name" "${descriptions[$mutant_name]}"

  # Copy the mutant as the solution script
  cp "$mutant_file" "${tmpdir}/${SOLUTION}"

  # Run bats from the temp directory so "bash ocr_numbers.sh" resolves
  if (cd "$tmpdir" && BATS_RUN_SKIPPED=true bats ocr_numbers.bats) > /dev/null 2>&1; then
    printf '    Result: ** SURVIVED **  (all tests passed despite the bug)\n\n'
    survived=$(( survived + 1 ))
  else
    printf '    Result: KILLED  (at least one test caught the mutation)\n\n'
    killed=$(( killed + 1 ))
  fi
done

printf '=%.0s' {1..60}
printf '\n  Summary: %d total, %d killed, %d survived\n' "$total" "$killed" "$survived"
printf '=%.0s' {1..60}
printf '\n'

if (( survived > 0 )); then
  printf '\n⚠  Surviving mutants indicate a gap in test coverage.\n'
  exit 1
else
  printf '\n✓  All mutants killed — full coverage for tested mutations.\n'
  exit 0
fi
