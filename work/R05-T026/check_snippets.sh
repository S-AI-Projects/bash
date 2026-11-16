#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
EXERCISE_DIR="${REPO_DIR}/exercises/practice/scrabble-score"
APPROACHES_DIR="${EXERCISE_DIR}/.approaches"

echo "=== Verifying Scrabble Score Approach Snippets (R05-T026) ==="

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

cp "${EXERCISE_DIR}/bats-extra.bash" "${TMP_DIR}/"
cp "${EXERCISE_DIR}/scrabble_score.bats" "${TMP_DIR}/"

check_snippet() {
    local name="$1"
    local snippet="$2"
    echo "Testing snippet: ${name}..."
    cp "${snippet}" "${TMP_DIR}/scrabble_score.sh"
    chmod +x "${TMP_DIR}/scrabble_score.sh"
    if (cd "${TMP_DIR}" && BATS_RUN_SKIPPED=true bats scrabble_score.bats > /dev/null 2>&1); then
        echo "  -> ${name}: PASSED (all 11 tests)"
    else
        echo "  -> ${name}: FAILED"
        exit 1
    fi
}

check_snippet "Associative Array" "${APPROACHES_DIR}/associative-array/snippet.txt"
check_snippet "Case With Letter Groups" "${APPROACHES_DIR}/case-with-letter-groups/snippet.txt"

echo ""
echo "All approach snippets passed all 11 Bats tests."
