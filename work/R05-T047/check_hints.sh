#!/usr/bin/env bash
#
# Checks for exercises/practice/rna-transcription/.docs/instructions.append.md
#
#   1. every ```bash example in the hints is RUN verbatim, and its output must
#      equal the "# => ..." comments written next to it (in order);
#   2. the hints must not give the solution away (no DNA->RNA mapping);
#   3. the two reference solutions in work/R05-T047/solutions/ pass all the
#      exercise's tests, and the two traps the hints warn about really fail;
#   4. markdownlint passes on the file (default rules).
#
# Usage (from anywhere inside the repo):  bash work/R05-T047/check_hints.sh
# Needs: bash, python3, bats; markdownlint-cli2 or npx (Node.js) for step 4.
# Exit status 0 only if every check passes.

set -u
root=$(git rev-parse --show-toplevel) || exit 1
ex=${root}/exercises/practice/rna-transcription
file=${ex}/.docs/instructions.append.md
sol=${root}/work/R05-T047/solutions
failures=0
fail() { echo "  FAIL: $*"; failures=$(( failures + 1 )); }

[[ -f ${file} ]] || { echo "missing ${file}" >&2; exit 1; }

echo "1. examples in the hints"
python3 -I - "${file}" <<'PY' || failures=$(( failures + 1 ))
import re, subprocess, sys
text = open(sys.argv[1]).read()
blocks = re.findall(r"```bash\n(.*?)```", text, re.S)
bad = 0
for n, code in enumerate(blocks, 1):
    expected = re.findall(r"# => (.*)", code)
    run = subprocess.run(["bash", "-c", code], capture_output=True, text=True)
    actual = run.stdout.splitlines()
    ok = expected == actual and run.returncode == 0 and run.stderr == ""
    print(f"  example {n}: {'ok' if ok else 'FAIL'}  expected {expected}  got {actual}")
    bad += not ok
print(f"  {len(blocks)} examples run")
sys.exit(1 if bad or len(blocks) < 3 else 0)
PY

echo "2. spoiler check (the hints must not contain the solution)"
if grep -nE 'GCTA|CGAU|ACGU|//[ACGTUacgtu]/[ACGTUacgtu]|G.{1,3}C.{1,3}T.{1,3}A.{1,3}U' "${file}"; then
    fail "the hints appear to contain the DNA to RNA mapping"
else
    echo "  ok: no DNA/RNA mapping in the file"
fi
count=$(grep -c '^### ' "${file}")
echo "  hints (### sections): ${count}"
(( count >= 3 && count <= 5 )) || fail "expected 3-5 hints, found ${count}"

echo "3. reference solutions and the traps"
command -v bats > /dev/null || fail "bats is required for this step"
run_tests() { # $1 = solution file; prints "<ok> <not ok>"
    local d out; d=$(mktemp -d)
    cp "${ex}/rna_transcription.bats" "${ex}/bats-extra.bash" "${d}/"
    cp "$1" "${d}/rna_transcription.sh"
    out=$( cd "${d}" && BATS_RUN_SKIPPED=true bats rna_transcription.bats 2>&1 )
    echo "$(grep -c '^ok ' <<< "${out}") $(grep -c '^not ok ' <<< "${out}")"
    rm -rf "${d}"
}
for s in solution_tr solution_substitution; do
    read -r okc nok <<< "$(run_tests "${sol}/${s}.sh")"
    echo "  ${s}: ${okc} ok, ${nok} not ok"
    (( okc == 9 && nok == 0 )) || fail "${s} should pass all 9 tests"
done
for s in trap_chained_substitution trap_print_before_validating; do
    read -r okc nok <<< "$(run_tests "${sol}/${s}.sh")"
    echo "  ${s}: ${okc} ok, ${nok} not ok (must fail)"
    (( nok > 0 )) || fail "${s} was expected to fail some tests"
done

echo "4. markdownlint"
if command -v markdownlint-cli2 > /dev/null; then lint=(markdownlint-cli2)
elif command -v npx > /dev/null; then lint=(npx --yes markdownlint-cli2)
else lint=(); fail "markdownlint-cli2 / npx not found"; fi
if (( ${#lint[@]} )); then
    if "${lint[@]}" "${file}" 2>&1 | sed 's/^/  /'; then :; fi
    "${lint[@]}" "${file}" > /dev/null 2>&1 || fail "markdownlint reported problems"
fi

echo
if (( failures == 0 )); then echo "ALL CHECKS PASSED"; else echo "${failures} CHECK(S) FAILED"; fi
(( failures == 0 ))
