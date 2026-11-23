#!/usr/bin/env bash
# run_mutants.sh: tests each of the 6 mutants and reports test results

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$DIR/../.." && pwd)"
EXERCISE_DIR="$REPO_ROOT/exercises/practice/allergies"

echo "=== Running Mutation Testing for allergies ==="

for m in 1 2 3 4 5 6; do
    echo "--- Testing Mutant $m ---"
    cp "$DIR/mutant${m}.sh" "$EXERCISE_DIR/allergies.sh"
    set +e
    output=$(cd "$EXERCISE_DIR" && BATS_RUN_SKIPPED=true bats allergies.bats 2>&1)
    status=$?
    set -e
    if [[ $status -ne 0 ]]; then
        first_killed=$(echo "$output" | grep "^not ok" | head -n 1)
        total_killed=$(echo "$output" | grep -c "^not ok" || true)
        echo "Mutant $m was KILLED by: $first_killed (Total failures: $total_killed)"
    else
        echo "Mutant $m SURVIVED (All tests passed!)"
    fi
done

git checkout "$EXERCISE_DIR/allergies.sh" >/dev/null 2>&1
echo "=== Mutation testing complete ==="
