#!/usr/bin/env bash
# check_snippets.sh: runs all 5 two-fer tests against each approach snippet.txt

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$DIR/../.." && pwd)"
EXERCISE_DIR="$REPO_ROOT/exercises/practice/two-fer"
APPROACHES_DIR="$EXERCISE_DIR/.approaches"

echo "=== Verifying two-fer approach snippets ==="

for approach in parameter-expansion argument-count; do
    snippet="$APPROACHES_DIR/$approach/snippet.txt"
    echo "--- Testing snippet for: $approach ---"
    [[ -f "$snippet" ]] || { echo "Error: $snippet not found" >&2; exit 1; }

    cp "$snippet" "$EXERCISE_DIR/two_fer.sh"
    output=$(cd "$EXERCISE_DIR" && BATS_RUN_SKIPPED=true bats two_fer.bats 2>&1)

    passed=$(echo "$output" | grep -c "^ok" || true)
    failed=$(echo "$output" | grep -c "^not ok" || true)

    echo "Results for $approach: $passed passed, $failed failed"
    if [[ "$failed" -eq 0 && "$passed" -eq 5 ]]; then
        echo "✓ All 5 tests passed for $approach"
    else
        echo "✗ Failed tests for $approach:"
        echo "$output" | grep "^not ok"
        git checkout "$EXERCISE_DIR/two_fer.sh" >/dev/null 2>&1
        exit 1
    fi
done

git checkout "$EXERCISE_DIR/two_fer.sh" >/dev/null 2>&1
echo "=== All approach snippets verified successfully ==="
