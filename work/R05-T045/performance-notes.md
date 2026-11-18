# R05-T045: Pythagorean Triplet Performance Optimization

## 1. Optimization

Replaced the original nested-loop brute-force search with an
O(N) mathematical approach.

The optimized implementation calculates the second side directly
using the perimeter and the first side, then checks divisibility
and validates the Pythagorean identity.

## 2. Original Bats baseline timings

Command:
BATS_RUN_SKIPPED=true RUN_HARD_TEST=true bats --timing pythagorean_triplet.bats

| Test | Original timing |
|---|---:|
| Sum 12 | 13 ms |
| Sum 108 | 21 ms |
| Sum 1000 | 865 ms |
| No triplets for 1001 | 865 ms |
| All triplets for 90 | 20 ms |
| Several triplets for 840 | 625 ms |
| Large input 30000 | Timing unavailable; test did not report completion during baseline run |

## 3. Optimized official Bats results

All 7 tests passed.

| Test | Optimized timing |
|---|---:|
| Sum 12 | 15 ms |
| Sum 108 | 13 ms |
| Sum 1000 | 15 ms |
| No triplets for 1001 | 15 ms |
| All triplets for 90 | 14 ms |
| Several triplets for 840 | 15 ms |
| Large input 30000 | 48 ms |

## 4. Hyperfine benchmark

Command:
hyperfine --warmup 1 --runs 5 \
'bash exercises/practice/pythagorean-triplet/.meta/example.sh 1000' \
'bash work/R05-T045/fast.sh 1000'

| Measurement | Original | Optimized |
|---|---:|---:|
| Mean wall time | 866.4 ms | 6.6 ms |
| Standard deviation | 16.5 ms | 0.2 ms |
| Minimum | 847.0 ms | 6.3 ms |
| Maximum | 884.8 ms | 6.9 ms |

Hyperfine-reported speedup: 131.9x faster.
Wall-time reduction: 99.2%.

## 5. Code quality

- All 7 official Bats tests passed.
- ShellCheck with -o all passed.
- git diff --check passed.
- Original exercise test files were not modified.
