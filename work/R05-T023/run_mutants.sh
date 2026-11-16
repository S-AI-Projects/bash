#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
EXERCISE_DIR="${REPO_DIR}/exercises/practice/roman-numerals"
MUTANTS_DIR="${SCRIPT_DIR}/mutants"

echo "=== Mutation Testing Report for roman-numerals (R05-T023) ==="
echo ""

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

cp "${EXERCISE_DIR}/bats-extra.bash" "${TMP_DIR}/"

# 1. Test against original 27 tests (without the new test)
git -C "${REPO_DIR}" show HEAD:exercises/practice/roman-numerals/roman_numerals.bats > "${TMP_DIR}/roman_numerals_27.bats"

echo "Phase 1: Testing all 6 mutants against original 27-test suite"
for m in "${MUTANTS_DIR}"/*.sh; do
    name="$(basename "$m")"
    cp "$m" "${TMP_DIR}/roman_numerals.sh"
    chmod +x "${TMP_DIR}/roman_numerals.sh"
    if (cd "${TMP_DIR}" && BATS_RUN_SKIPPED=true bats roman_numerals_27.bats > /dev/null 2>&1); then
        echo "  - ${name}: SURVIVED (behavior not caught by 27 tests)"
    else
        echo "  - ${name}: KILLED"
    fi
done

echo ""
echo "Phase 2: Testing surviving mutant against updated 28-test suite (with '444 is CDXLIV')"
cp "${EXERCISE_DIR}/roman_numerals.bats" "${TMP_DIR}/roman_numerals_28.bats"
cp "${MUTANTS_DIR}/mutant6_pair_combo.sh" "${TMP_DIR}/roman_numerals.sh"
chmod +x "${TMP_DIR}/roman_numerals.sh"

if (cd "${TMP_DIR}" && BATS_RUN_SKIPPED=true bats roman_numerals_28.bats > /dev/null 2>&1); then
    echo "  - mutant6_pair_combo.sh: STILL SURVIVED (Unexpected)"
    exit 1
else
    echo "  - mutant6_pair_combo.sh: KILLED by new test '444 is CDXLIV'"
fi

echo ""
echo "Phase 3: Verifying reference example passes all 28 tests"
cp "${EXERCISE_DIR}/.meta/example.sh" "${TMP_DIR}/roman_numerals.sh"
chmod +x "${TMP_DIR}/roman_numerals.sh"

if (cd "${TMP_DIR}" && BATS_RUN_SKIPPED=true bats roman_numerals_28.bats > /dev/null 2>&1); then
    echo "  - example.sh: ALL 28 TESTS PASSED"
else
    echo "  - example.sh: FAILED"
    exit 1
fi

echo ""
echo "Automated mutation checks completed successfully."
