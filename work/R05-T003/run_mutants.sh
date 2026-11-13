#!/usr/bin/env bash
# Runs clock's bats tests against every mutant in ./mutants/ (in a temp copy)
# and reports which tests kill each one. Needs bash 4+ and bats on PATH.
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(cd "$here/../.." && pwd)
ex=$root/exercises/practice/clock
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
cp "$ex/clock.bats" "$ex/bats-extra.bash" "$tmp/"

run_tests() {   # $1 = solution file; prints failing test names, one per line
    cp "$1" "$tmp/clock.sh"
    (cd "$tmp" && BATS_RUN_SKIPPED=true bats --tap clock.bats 2>&1) |
        sed -n 's/^not ok [0-9]* //p'
}

total=$(grep -cE '^(test_|@test)' "$ex/clock.bats")

# Control: the real example must pass every test, or the results mean nothing.
control=$(run_tests "$ex/.meta/example.sh")
if [[ -n $control ]]; then
    echo "CONTROL FAILED: example.sh fails these tests (check bash >= 4 and bats):"
    echo "$control"
    exit 1
fi
echo "control: example.sh passes all $total tests"
echo

killed=0 survived=()
for mutant in "$here"/mutants/*.sh; do
    name=$(basename "$mutant" .sh)
    failing=$(run_tests "$mutant")
    if [[ -z $failing ]]; then
        printf '%-28s SURVIVED (all %d tests pass)\n' "$name" "$total"
        survived+=("$name")
    else
        count=$(grep -c . <<<"$failing")
        first=$(head -1 <<<"$failing")
        printf '%-28s KILLED by %d of %d tests (e.g. %s)\n' "$name" "$count" "$total" "$first"
        ((killed++))
    fi
done

echo
echo "killed: $killed   survived: ${#survived[@]}"
(( ${#survived[@]} )) && printf 'survivor: %s\n' "${survived[@]}"
exit 0
