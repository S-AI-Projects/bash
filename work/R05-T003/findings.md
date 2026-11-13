# R05-T003: mutation-driven test for clock

## Goal
Plant small bugs (mutants) in a copy of clock's `.meta/example.sh`, find
behaviour the 58 existing tests do not check, and add a track-specific test for it.

## Method
- `make_mutants.sh` writes 11 mutants into `mutants/`. Each has exactly one change.
- `run_mutants.sh` copies `clock.bats` and `bats-extra.bash` to a temp dir, runs
  the tests against each mutant, and reports which tests fail (kill it). It first
  runs a control with the real `example.sh`, which must pass every test.
- The real `example.sh` is never modified.

## Mutants
| Mutant | Change | Before (58 tests) | After (59 tests) |
|---|---|---|---|
| m01_carry_two_hours | borrow 2 hours per minute wrap | killed by 9 | killed by 9 |
| m02_wrap_23_hours | wrap at 23*60 minutes | killed by 15 | killed by 15 |
| m03_minutes_mod_59 | `minutes % 59` in output | killed by 31 | killed by 32 |
| m04_drop_hours_mod | drop `% 24` on output hours | killed by 3 | killed by 3 |
| m05_negative_fix_once | negative fix-up runs once, not in a loop | killed by 1 | killed by 2 |
| m06_negative_fix_max_2 | negative fix-up runs at most twice | **SURVIVED** | killed by 1 |
| m07_negative_fix_max_5 | negative fix-up runs at most five times | **SURVIVED** | killed by 1 |
| m08_negative_boundary | `minutes < -1` instead of `minutes < 0` | killed by 1 | killed by 1 |
| m09_drop_negative_hours | remove the negative-hour loop | killed by 7 | killed by 7 |
| m10_drop_negative_mins | remove the negative-minute loop | killed by 3 | killed by 3 |
| m11_equal_inverted | invert the `=` result | killed by 16 | killed by 16 |

## Survivors
`m06_negative_fix_max_2` and `m07_negative_fix_max_5`, both aimed at the
negative-minute modulo arithmetic. Bash's `%` keeps the sign of the dividend, so
`example.sh` repeatedly adds 24*60 until the total is non-negative. The existing
tests never need more than two repetitions (the largest is "subtract more than
two days"), so a solution that wraps only a limited number of times passes all 58.

## New test
Added at the end of `exercises/practice/clock/.meta/template.j2`:
`test_large_negative_delta_wraps_many_days` runs `clock.sh 10 0 - 100000` and expects
`23:20`. That total is -99400 minutes, which needs 70 wraps. `clock.bats` was
regenerated with `bin/generate_tests clock`, not edited by hand, and now has 59 tests.

## Results
- Validator: 59 of 59 tests ok with the real `example.sh`.
- `run_mutants.sh` after the change: killed 11, survived 0; m06 and m07 are now
  killed by the new test.
- Raw output: `before.txt` and `after.txt` in this folder.

## Environment notes
- My copy of `bin/generate_tests` has no `--no-pull` flag (pulling is off by
  default), so I ran `python3 bin/generate_tests clock`.
- On macOS the tests were run with bash 5, GNU grep and `bats-core` from Homebrew.
