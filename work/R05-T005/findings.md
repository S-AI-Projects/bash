# R05-T005: faster palindrome-products example

## Goal
Measure the reference solution on its slowest tests and replace it with a
faster, still idiomatic version.

## Baseline (`BATS_RUN_SKIPPED=true bats --timing palindrome_products.bats`)
Slowest tests with the old `example.sh` (full output in `bats_timing_before.txt`):

| Test | Time |
|---|---|
| test_find_the_largest_palindrome_from_four_digit_factors (largest 1000 9999) | 9425 ms |
| test_smallest_product_does_not_use_the_smallest_factor (smallest 3215 4000) | 6001 ms |
| test_find_the_largest_palindrome_from_triple_digit_factors (largest 100 999) | 910 ms |

All other tests took under 40 ms.

## Why it is slow
The old `main` walks through every possible product, from `max^2` downwards (or
`min^2` upwards), tests each one for being a palindrome, and only then looks for
factors. For `largest 1000 9999` that is about 980,000 candidates, each checked
with a Bash function call.

## Change
`work/R05-T005/fast.sh` (now `.meta/example.sh`) searches factor pairs instead:
- `largest`: loop `a` from `max` down and `b` from `a` down. Products only get
  smaller, so once `a * b` is not bigger than the best palindrome found, no
  later `b` can beat it, and once `a * a` is smaller than the best, no later `a`
  can either.
- `smallest`: the same search in the other direction.
- A product that ends in 0 cannot be a palindrome, so `smallest_palindrome`
  skips it without calling `is_palindrome`.
- The palindrome is then passed to `factors`, which prints every factor pair in
  the same format as before.

`main`, `factors`, `die` and `is_palindrome` keep their names and purpose.
`smallest_palindrome` and `largest_palindrome` are new helpers, each with a
comment. The argument checks and error messages are unchanged.

## Benchmark
`hyperfine --warmup 0 --runs 3` on the slowest test's input, `largest 1000 9999`
(`hyperfine.md`):

| Version | Mean | Range |
|---|---|---|
| old `.meta/example.sh` | 9.370 s +/- 0.076 s | 9.314 s .. 9.457 s |
| new `fast.sh` | 0.037 s +/- 0.001 s | 0.036 s .. 0.038 s |

The new version is 253.8x faster (-99.6%). `bats_timing_after.txt` has the
per-test times after the change.

## Results
- `bin/validate_one_exercise exercises/practice/palindrome-products`: 14 of 14
  tests ok.
- `shellcheck -o all exercises/practice/palindrome-products/.meta/example.sh`:
  no output.
- The old example did not pass plain `shellcheck`; the new one passes with `-o all`.

## Environment notes
- On macOS the tests were run with bash 5, GNU grep, `bats-core`, `shellcheck`
  and `hyperfine` from Homebrew.

## Per-test timings after the change (`bats_timing_after.txt`)
| Test | Before | After |
|---|---|---|
| largest 1000 9999 | 9425 ms | 39 ms |
| smallest 3215 4000 | 6001 ms | 537 ms |
| largest 100 999 | 910 ms | 76 ms |
| smallest 1000 9999 | 37 ms | 38 ms |

No test got slower. The skip of products ending in 0 keeps the smallest
four-digit test at its old speed.
