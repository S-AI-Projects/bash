# R05-T021 — List Ops Fold Cases

## Summary

Enabled the six original canonical foldl and foldr test cases by removing
their `include = false` entries from `exercises/practice/list-ops/.meta/tests.toml`.

## Investigation

Inspected the canonical data from Exercism problem-specifications and the
Bash exercise implementation, template, and appended instructions.

Tested all six original cases against a scratch copy of `.meta/example.sh`:

- foldl with an empty list: passed (2)
- foldl with addition: passed (15)
- foldl with integer division: passed (0)
- foldr with an empty list: passed (2)
- foldr with addition: passed (15)
- foldr with integer division: passed (2)

All six cases are supported by the existing Bash implementation.

## Validation

- `python3 bin/generate_tests --no-pull list-ops` — passed.
- Generated test reproducibility check — passed.
- `bin/validate_one_exercise exercises/practice/list-ops` — passed; all 20 tests passed.
- `bin/configlet lint` — blocked by the repository's missing
  `docs/SIGN_UP_SNIPPET.txt`. The tracked file is `docs/SNIPPET.txt`.
  No unrelated repository files were changed.

## Changes

Only the six `include = false` entries were removed. No implementation or
generated test files were modified.
