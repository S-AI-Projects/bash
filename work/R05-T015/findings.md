# Task R05-T015 Findings: Speed up the 'nth-prime' example

## Student Information
- Name: ARYA PRAJAPATI
- Task ID: R05-T015
- Issue: #19

## Optimization Summary
1. **Removed `bc` dependency**:
   - The original solution piped to `bc -l` in `approxNth` to compute natural logarithm $2 + 1.2 \cdot n \cdot \ln(n)$.
   - Replaced with a fast pure-bash integer natural log approximation `approx_ln` using bit extraction and rational polynomial approximation ($O(1)$ arithmetic in bash).
2. **Odd-Only Sieve of Eratosthenes**:
   - Halved array storage requirements by only indexing odd numbers ($k = p / 2$).
   - Avoided costly $O(N)$ string initialization (`is_prime[i]=true`) by taking advantage of default arithmetic zero-values (`!composite[k]`).
   - Sieve terminates collection as soon as the target count $n$ is reached.

## Benchmark Results (Hyperfine)

| Input $n$ | Old Implementation (`bc` based) | New Implementation (Pure Bash Sieve) | Speedup |
|---|---|---|---|
| $n = 1$ | 6.7 ms ± 0.6 ms | 4.3 ms ± 0.2 ms | **1.5x faster** (-35.1%) |
| $n = 100$ | 9.0 ms ± 0.2 ms | 6.0 ms ± 0.3 ms | **1.5x faster** (-33.2%) |
| $n = 1000$ | 38.1 ms ± 1.2 ms | 18.0 ms ± 0.9 ms | **2.1x faster** (-52.7%) |
| $n = 10001$ | 430.0 ms ± 2.0 ms | 179.1 ms ± 1.9 ms | **2.4x faster** (-58.4%) |

Memory usage for $n = 10001$ dropped from 12.2 MiB to 9.4 MiB (-23.2%).

## Verification
- Baseline Bats timing on $n = 10001$ recorded in `work/R05-T015/baseline_timing.txt` (433 ms).
- All 5 tests in `nth_prime.bats` pass cleanly via `bin/validate_one_exercise exercises/practice/nth-prime`.
- `shellcheck -o all exercises/practice/nth-prime/.meta/example.sh` passes with 0 warnings.
