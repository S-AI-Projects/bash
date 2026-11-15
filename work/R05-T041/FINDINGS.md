# R05-T041: unexplained exclusions in armstrong-numbers

Both cases come from `problem-specifications/exercises/armstrong-numbers/canonical-data.json`.

| Case | Input | Digits | Input / bash max (9223372036854775807) | 9**digits | Expected |
|---|---|---|---|---|---|
| Armstrong number containing seven zeroes | 186709961001538790100634132976990 | 33 | ~2.0e13 | ~3.1e31 | true |
| The largest and last Armstrong number | 115132219018763992565095597973971522401 | 39 | ~1.2e19 | ~1.6e38 | true |

## What happens in example.sh
Both inputs are far above bash's signed 64-bit maximum, and so is even a single digit term (9**33, 9**39).
`$((digit**power))` silently wraps, the sum is wrong (66560933741595104606 for the first,
a negative number for the second), the `[ $sum -eq $number ]` test errors with
"integer expression expected", and the script prints `false` instead of `true`.
See `overflow_check.out` and `size_comparison.txt`.

## Decision
Neither case can be supported with native bash arithmetic, so both stay excluded and now carry a
`comment` explaining why (same format as `anagram/.meta/tests.toml`).
Supporting them would need arbitrary-precision arithmetic (an external tool such as `bc`,
or hand-written big-number string arithmetic), which goes against the track's pure-bash teaching goal.

## Verification
- `bin/generate_tests` re-run: the `.bats` file is unchanged (only the generated-on date would differ).
- Test cases run against example.sh: 9/9 included cases pass.
- `bats` was not installed in the environment used, so `bin/validate_one_exercise` was emulated by hand; run it locally before opening the PR.
