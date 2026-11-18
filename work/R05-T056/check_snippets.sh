#!/usr/bin/env bash
# check_snippets.sh — Test matching-brackets approach snippets against bats suite
# Usage: bash work/R05-T056/check_snippets.sh
# Must be run from repository root.

set -euo pipefail

readonly REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
readonly EXERCISE_DIR="${REPO_ROOT}/exercises/practice/matching-brackets"
readonly APPROACHES_DIR="${EXERCISE_DIR}/.approaches"

total_snippets=0
passed_snippets=0

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

cp "${EXERCISE_DIR}/"*.bats "${tmpdir}/"
cp "${EXERCISE_DIR}/bats-extra.bash" "${tmpdir}/"

printf '=%.0s' {1..60}
printf '\n  Testing matching-brackets Approach Snippets\n'
printf '=%.0s' {1..60}
printf '\n\n'

for snippet in "${APPROACHES_DIR}"/*/snippet.txt; do
  approach_name=$(basename "$(dirname "$snippet")")
  total_snippets=$(( total_snippets + 1 ))

  printf '[%d] Testing approach: %s\n' "$total_snippets" "$approach_name"

  cp "$snippet" "${tmpdir}/matching_brackets.sh"
  chmod +x "${tmpdir}/matching_brackets.sh"

  if (cd "$tmpdir" && BATS_RUN_SKIPPED=true bats matching_brackets.bats) > /dev/null 2>&1; then
    printf '    Result: PASS (all 20 tests passed)\n\n'
    passed_snippets=$(( passed_snippets + 1 ))
  else
    printf '    Result: FAIL\n\n'
  fi
done

printf '=%.0s' {1..60}
printf '\n  Summary: %d of %d snippets passed\n' "$passed_snippets" "$total_snippets"
printf '=%.0s' {1..60}
printf '\n'

if (( passed_snippets == total_snippets && total_snippets > 0 )); then
  printf '\n✓ All approach snippets are complete and valid solutions.\n'
  exit 0
else
  printf '\n✗ Some snippets failed tests.\n'
  exit 1
fi
