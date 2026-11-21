#!/usr/bin/env bash
#
# Check the isogram approaches articles.
#
# For every approach listed in .approaches/config.json this script:
#   1. runs the exercise's own isogram.bats against the approach's snippet.txt
#      (copied to isogram.sh in a temp directory) and requires every test to pass;
#   2. checks the snippet is at most 8 lines (the limit configlet lint applies);
#   3. checks the snippet text appears verbatim in that approach's content.md
#      and in introduction.md, so the articles cannot drift from the tested code;
#   4. checks the approach folder, slug and uuid are consistent (uuid unique in the track).
# It also runs the reference solution (.meta/example.sh) as a baseline.
#
# Usage (from anywhere inside the repo):  bash work/R05-T046/check_snippets.sh
# Needs: bats, jq, python3.  Exit status 0 only if every check passes.

set -u
root=$(git rev-parse --show-toplevel) || exit 1
ex=${root}/exercises/practice/isogram
app=${ex}/.approaches
command -v bats > /dev/null || { echo "bats is required" >&2; exit 1; }
command -v jq   > /dev/null || { echo "jq is required" >&2; exit 1; }

tmp=$(mktemp -d) || exit 1
trap 'rm -rf "${tmp}"' EXIT
failures=0
fail() { echo "  FAIL: $*"; failures=$(( failures + 1 )); }

# Run isogram.bats against a candidate solution file; sets tests_total / tests_failed.
run_tests() { # $1 = solution file
    local d; d=$(mktemp -d -p "${tmp}")
    cp "${ex}/isogram.bats" "${ex}/bats-extra.bash" "${d}/"
    cp "$1" "${d}/isogram.sh"
    local out
    out=$( cd "${d}" && BATS_RUN_SKIPPED=true bats isogram.bats 2>&1 )
    tests_total=$(grep -cE '^(not )?ok ' <<< "${out}")
    tests_failed=$(grep -c '^not ok ' <<< "${out}")
    printf '%s\n' "${out}" | grep '^not ok ' | sed 's/^/    /'
}

expected=$(grep -c '^@test' "${ex}/isogram.bats")
echo "isogram.bats has ${expected} tests"

echo "baseline: .meta/example.sh"
run_tests "${ex}/.meta/example.sh"
echo "  ${tests_total} run, ${tests_failed} failed"
(( tests_total == expected && tests_failed == 0 )) || fail "the reference solution does not pass"

[[ -f ${app}/config.json && -f ${app}/introduction.md ]] || fail "config.json or introduction.md is missing"
jq empty "${app}/config.json" || fail "config.json is not valid JSON"

all_uuids=$(grep -rhoE '"uuid": "[0-9a-f-]+"' "${root}"/exercises/*/*/.approaches/config.json | sort)
mapfile -t slugs < <(jq -r '.approaches[].slug' "${app}/config.json")
(( ${#slugs[@]} >= 2 )) || fail "expected at least two approaches, found ${#slugs[@]}"

for slug in "${slugs[@]}"; do
    echo "approach: ${slug}"
    dir=${app}/${slug}
    [[ -f ${dir}/snippet.txt && -f ${dir}/content.md ]] || { fail "${slug}: snippet.txt or content.md is missing"; continue; }

    run_tests "${dir}/snippet.txt"
    echo "  ${tests_total} run, ${tests_failed} failed"
    (( tests_total == expected && tests_failed == 0 )) || fail "${slug}: snippet does not pass all ${expected} tests"

    lines=$(wc -l < "${dir}/snippet.txt")
    (( lines <= 8 )) || fail "${slug}: snippet has ${lines} lines (max 8)"

    for article in "${dir}/content.md" "${app}/introduction.md"; do
        python3 -I - "${dir}/snippet.txt" "${article}" <<'PY' || fail "${slug}: snippet text not found verbatim in ${article#"${root}"/}"
import sys
snippet = open(sys.argv[1]).read().rstrip("\n")
sys.exit(0 if snippet in open(sys.argv[2]).read() else 1)
PY
    done

    uuid=$(jq -r --arg s "${slug}" '.approaches[] | select(.slug == $s) | .uuid' "${app}/config.json")
    [[ ${uuid} =~ ^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$ ]] || fail "${slug}: uuid '${uuid}' is not a v4 uuid"
    (( $(grep -c "${uuid}" <<< "${all_uuids}") == 1 )) || fail "${slug}: uuid is not unique in the track"
    [[ -n $(jq -r --arg s "${slug}" '.approaches[] | select(.slug == $s) | .title + .blurb' "${app}/config.json") ]] || fail "${slug}: title/blurb missing"
done

for d in "${app}"/*/; do
    name=$(basename "${d}")
    printf '%s\n' "${slugs[@]}" | grep -qx "${name}" || fail "folder '${name}' is not listed in config.json"
done

echo
if (( failures == 0 )); then echo "ALL CHECKS PASSED"; else echo "${failures} CHECK(S) FAILED"; fi
(( failures == 0 ))
