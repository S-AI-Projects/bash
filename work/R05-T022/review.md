# R05-T022 — Baffling Birthdays Test Template

## Summary

Created the missing test template `exercises/practice/baffling-birthdays/.meta/template.j2` so that tests can be reliably regenerated when canonical data changes.

## Investigation & Design

- Read `bin/generate_tests` to understand how canonical cases are flattened, filtered, and passed to Jinja2 templates.
- Examined existing templates such as `resistor-color-duo` and `two-fer`.
- Identified that `baffling-birthdays` contains 17 Bats tests covering three properties:
  1. `sharedBirthday` (canonical test cases)
  2. `randomBirthdates` (property-based assertions for output count, non-leap years, random month distribution, and random day distribution)
  3. `estimatedProbabilityOfSharedBirthday` (probability estimation tests using `assert_between` tolerances)
- Structured `template.j2` to loop over `sharedBirthday` cases, generate hand-written property blocks for `randomBirthdates`, and handle tolerance assertions for `estimatedProbabilityOfSharedBirthday`.

## Validation

- `python3 bin/generate_tests --no-pull baffling-birthdays` — passed.
- Test reproducibility check:
  `git diff --exit-code -I '^# generated on' exercises/practice/baffling-birthdays/baffling_birthdays.bats` — passed with 0 differences.
- `bin/validate_one_exercise exercises/practice/baffling-birthdays` — passed; all 17 tests passed.
- `bin/configlet lint` — completed; missing `docs/SIGN_UP_SNIPPET.txt` is an upstream repository issue and no unrelated files were touched.

## Changes

- Added `exercises/practice/baffling-birthdays/.meta/template.j2`.
- Added `work/R05-T022/review.md`.
