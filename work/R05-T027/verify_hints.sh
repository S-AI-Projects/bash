#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
EXERCISE_DIR="${REPO_DIR}/exercises/practice/secret-handshake"

echo "=== Verifying secret-handshake hints and solution (R05-T027) ==="

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

cp "${EXERCISE_DIR}/bats-extra.bash" "${TMP_DIR}/"
cp "${EXERCISE_DIR}/secret_handshake.bats" "${TMP_DIR}/"
cp "${SCRIPT_DIR}/solution.sh" "${TMP_DIR}/secret_handshake.sh"

echo "Running full Bats test suite on work/R05-T027/solution.sh..."
(cd "${TMP_DIR}" && BATS_RUN_SKIPPED=true bats secret_handshake.bats)

echo ""
echo "Running markdownlint..."
npx --yes markdownlint-cli2 "${EXERCISE_DIR}/.docs/instructions.append.md"

echo ""
echo "All verifications passed."
