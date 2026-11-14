#!/usr/bin/env bash
# Runs all the leap tests against the snippet.txt of every approach in
# exercises/practice/leap/.approaches. The snippets only contain the leap
# calculation, so each one is placed after the same argument validation
# (the four "should return an error" tests) to make a complete solution.
# Needs bats on PATH; the external-tools approach also needs GNU date
# (macOS: brew install coreutils).
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(cd "$here/../.." && pwd)
ex=$root/exercises/practice/leap
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Use GNU date if the system date is not GNU (macOS ships BSD date).
if ! date --version >/dev/null 2>&1 && command -v brew >/dev/null 2>&1; then
    gnubin="$(brew --prefix coreutils 2>/dev/null)/libexec/gnubin"
    [[ -d $gnubin ]] && PATH="$gnubin:$PATH"
fi
date --version >/dev/null 2>&1 || echo "warning: GNU date not found; the external-tools approach will fail"

cp "$ex/leap.bats" "$ex/bats-extra.bash" "$tmp/"

# Argument validation shared by every approach.
preamble='#!/usr/bin/env bash
usage() { echo "Usage: leap.sh <year>" >&2; exit 1; }
(( $# == 1 )) && [[ $1 =~ ^[0-9]+$ ]] || usage
'
total=$(grep -cE '^(test_|@test)' "$ex/leap.bats")
status=0

for snippet in "$ex"/.approaches/*/snippet.txt; do
    approach=$(basename "$(dirname "$snippet")")
    { printf '%s\n' "$preamble"; cat "$snippet"; } > "$tmp/leap.sh"
    output=$(cd "$tmp" && BATS_RUN_SKIPPED=true bats --tap leap.bats 2>&1)
    failed=$(grep -c '^not ok' <<<"$output")
    passed=$(grep -c '^ok' <<<"$output")
    if (( failed == 0 && passed == total )); then
        printf '%-20s PASS (%d of %d tests)\n' "$approach" "$passed" "$total"
    else
        printf '%-20s FAIL (%d of %d tests passed)\n' "$approach" "$passed" "$total"
        grep '^not ok' <<<"$output"
        status=1
    fi
done

exit "$status"
