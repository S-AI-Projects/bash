#!/usr/bin/env bash
# Runs yacht bats tests against every mutant in ./mutants/ (in a temporary directory)
# and reports which tests kill each one.
set -euo pipefail

# Ensure Homebrew bins (bats, modern bash) are in PATH
export PATH="/opt/homebrew/bin:/opt/homebrew/opt/grep/libexec/gnubin:$PATH"

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(cd "$here/../.." && pwd)
ex=$root/exercises/practice/yacht
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

cp "$ex/yacht.bats" "$ex/bats-extra.bash" "$tmp/"

run_tests() {
    local sol=$1
    cp "$sol" "$tmp/yacht.sh"
    ( (cd "$tmp" && BATS_RUN_SKIPPED=true bats --tap yacht.bats 2>&1) || true ) |
        sed -n 's/^not ok [0-9]* //p'
}

total=$(grep -cE '^@test' "$ex/yacht.bats")

# Control: real example must pass all tests
control=$(run_tests "$ex/.meta/example.sh")
if [[ -n $control ]]; then
    echo "CONTROL FAILED: example.sh fails these tests:"
    echo "$control"
    exit 1
fi
echo "control: example.sh passes all $total tests"
echo

killed=0
survived=()

for mutant in "$here"/mutants/*.sh; do
    name=$(basename "$mutant" .sh)
    failing=$(run_tests "$mutant")
    if [[ -z $failing ]]; then
        printf '%-30s SURVIVED (all %d tests pass)\n' "$name" "$total"
        survived+=("$name")
    else
        count=$(grep -c . <<<"$failing")
        first=$(head -1 <<<"$failing")
        printf '%-30s KILLED by %d of %d tests (e.g. %s)\n' "$name" "$count" "$total" "$first"
        killed=$(( killed + 1 ))
    fi
done

echo
echo "killed: $killed   survived: ${#survived[@]}"
if (( ${#survived[@]} > 0 )); then
    printf 'survivor: %s\n' "${survived[@]}"
fi
exit 0
