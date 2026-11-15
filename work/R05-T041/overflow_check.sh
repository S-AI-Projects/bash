#!/usr/bin/env bash
# Evidence for R05-T041: can bash integers hold the two excluded armstrong-numbers cases?
# Run from the repo root:  bash work/R05-T041/overflow_check.sh
example=exercises/practice/armstrong-numbers/.meta/example.sh
max=9223372036854775807

echo "bash version : $BASH_VERSION"
echo "bash max int : $max (${#max} digits)"
echo "max + 1      : $((max + 1))   <- wraps to the minimum"
echo

declare -A cases=(
  ["Armstrong number containing seven zeroes"]=186709961001538790100634132976990
  ["The largest and last Armstrong number"]=115132219018763992565095597973971522401
)
for name in "Armstrong number containing seven zeroes" "The largest and last Armstrong number"; do
  n=${cases[$name]}
  echo "== $name"
  echo "   input    : $n (${#n} digits)"
  echo "   9**${#n}   : $((9 ** ${#n}))   <- a single digit term already overflows (true value is ~1e${#n})"
  echo "   example.sh output (expected: true):"
  bash "$example" "$n" 2>&1 | sed 's/^/     /'
  echo
done
