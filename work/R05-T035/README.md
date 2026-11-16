# Task R05-T035: Speed up the Sieve of Eratosthenes Reference Example (Issue #37)

## Overview & Objective
Measure and profile the reference solution (`exercises/practice/sieve/.meta/example.sh`) on its slowest test input (`limit=1000`) and replace it with a significantly faster, idiomatic Bash version complying with `POLICIES.md` and the Google Shell Style Guide, without changing observable behavior or interface semantics.

---

## Baseline Analysis & Performance Bottlenecks

### Slowest Test Identification
Inspecting `exercises/practice/sieve/sieve.bats` revealed five test cases:
1. `no primes under two` (`limit=1`)
2. `find first prime` (`limit=2`)
3. `find primes up to 10` (`limit=10`)
4. `limit is prime` (`limit=13`)
5. `find primes up to 1000` (`limit=1000`)

Running `BATS_RUN_SKIPPED=true bats --timing sieve.bats` on the original reference solution confirmed that test 5 (`find primes up to 1000`) is the dominant bottleneck, taking **35ms** (nearly 30% of entire suite duration).

### Bottlenecks in the Original Implementation
The original `.meta/example.sh` suffered from several fundamental algorithmic and Bash interpreter overheads:

```bash
#!/usr/bin/env bash

# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

declare -i limit=$1

is_prime=()
for ((i = 2; i <= limit; i++)); do
    is_prime[i]=true
done

for ((p = 2; p <= limit; p++)); do
    # If this p is prime ...
    if ${is_prime[$p]}; then

        # ... then mark all multiples as not prime
        for (( m = 2 * p; m <= limit; m += p )); do
            is_prime[m]=false
        done
    fi
done

primes=()
for ((p = 2; p <= limit; p++)); do
    if ${is_prime[p]}; then
        primes+=( $p )
    fi
done

echo "${primes[*]}"
```

1. **Unnecessary O(N) Array Pre-allocation Loop:**
   - The loop `for ((i = 2; i <= limit; i++)); do is_prime[i]=true; done` performs 1,000 string assignments in Bash. In interpreted shell scripts, allocating array indices one-by-one is expensive.
2. **Command Dispatch for Boolean Condition Checks:**
   - The conditions `if ${is_prime[$p]}; then` and `if ${is_prime[p]}; then` expand to the strings `"true"` or `"false"` and execute them as shell commands/builtins. Evaluating shell commands in a loop of 1,000 numbers invokes command parsing, lookup, and status handling repeatedly.
3. **Inefficient Loop Bounds ($p \le limit$ vs $p \times p \le limit$):**
   - The outer sieving loop iterates $p$ from 2 all the way to $limit$ (1,000 iterations). By mathematical definition of the Sieve of Eratosthenes, all composite numbers $\le limit$ have at least one prime factor $\le \sqrt{limit}$. For $limit=1000$, $\sqrt{1000} \approx 31$. Continuing the sieving loop past 31 performs redundant iterations and condition checks.
4. **Redundant Multiple Marking ($2 \times p$ vs $p \times p$):**
   - Starting the inner marking loop at $m = 2 \times p$ re-marks composite numbers that were already marked by earlier, smaller prime factors (e.g., for $p=5$, $2 \times 5 = 10$, $3 \times 5 = 15$, and $4 \times 5 = 20$ are already marked by 2 and 3). The smallest unmarked multiple of any prime $p$ is always $p^2$.
5. **Redundant Checking of Even Numbers:**
   - The number 2 is the only even prime. All even numbers greater than 2 are composite. Checking and stepping through even numbers doubles the number of iterations in the outer loop, inner loop, and final collection pass.
6. **Code Style & ShellCheck Violations:**
   - The original solution failed `shellcheck -o all` with SC2250 (missing braces around variable expansions: `${is_prime[$p]}`) and SC2206 (unquoted array append: `primes+=( $p )`).
   - It lacked Google Shell Style Guide elements: structured header comments, function docstrings, local variable scoping, and a standard `main "$@"` entrypoint.

---

## New Marking Strategy & Implementation

The new reference implementation (`work/R05-T035/fast.sh` and `exercises/practice/sieve/.meta/example.sh`) addresses every bottleneck:

```bash
#!/usr/bin/env bash
#
# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

set -o errexit
set -o nounset

#######################################
# Find all prime numbers up to a given limit using the Sieve of Eratosthenes.
# Arguments:
#   Limit integer
# Outputs:
#   Space-separated list of prime numbers
#######################################
main() {
  local -i limit="${1:-0}"
  local -a is_composite=()
  local -a primes=()
  local -i p m

  # Sieve odd composite numbers starting from 3 up to sqrt(limit)
  for (( p = 3; p * p <= limit; p += 2 )); do
    if (( !is_composite[p] )); then
      for (( m = p * p; m <= limit; m += 2 * p )); do
        is_composite[m]=1
      done
    fi
  done

  # 2 is the only even prime
  if (( limit >= 2 )); then
    primes+=(2)
  fi

  # Collect odd primes up to limit
  for (( p = 3; p <= limit; p += 2 )); do
    if (( !is_composite[p] )); then
      primes+=("${p}")
    fi
  done

  echo "${primes[*]}"
}

main "${@}"
```

### Key Differences & Architectural Changes

| Aspect | Old Strategy (`example.sh` original) | New Strategy (`fast.sh` / updated `example.sh`) | Impact |
|---|---|---|---|
| **Array Semantics** | `is_prime`: dense array storing `"true"` / `"false"` strings | `is_composite`: sparse array tracking composite markers (`1`) | Unset indices evaluate to 0 in arithmetic context, eliminating the pre-allocation loop. |
| **Initialization Cost** | 1,000 array assignments in a loop ($O(N)$) | 0 iterations ($O(1)$ empty declaration `local -a is_composite=()`) | Completely eliminates pre-allocation loop overhead. |
| **Condition Evaluation** | Command evaluation (`${is_prime[$p]}`) | Native arithmetic evaluation `(( !is_composite[p] ))` | Eliminates command execution dispatch in Bash. |
| **Outer Loop Bound** | $p \le limit$ ($p = 2 \dots 1000$, 999 iterations) | $p \times p \le limit$ ($p = 3, 5 \dots 31$, 15 iterations) | 98.5% reduction in outer loop iterations. |
| **Inner Loop Start** | $m = 2 \times p$ (re-marks earlier composites) | $m = p \times p$ (skips already marked multiples) | Eliminates redundant writes to composite array. |
| **Inner Loop Step** | $m \mathrel{+}= p$ (marks both even and odd multiples) | $m \mathrel{+}= 2 \times p$ (only marks odd multiples) | Halves inner loop writes. |
| **Even Number Handling** | Tested and marked throughout all loops | 2 added directly if `limit >= 2`; even numbers skipped | Halves collection loop iterations. |
| **ShellCheck** | 2 warnings/style issues (SC2250, SC2206) | Clean: 0 warnings, 0 style notes with `shellcheck -o all` | 100% compliant with static analysis. |
| **Style & Structure** | Root-level statements, global variables | Google Shell Style Guide: `main "$@"`, typed `local -i`/`local -a`, 2-space indent, function docstrings | Production quality and maintainability. |

---

## Benchmark Results

### Hyperfine Benchmark (`limit=1000`)
Benchmarks were executed using `hyperfine` with 20 warmup runs and a minimum of 100 runs per implementation:

```text
Benchmark 1: Original (.meta/example.sh) (154 runs)
                mean     ±       σ          min     …     max
  Wall Time     19.1 ms  ±     0.4 ms      18.2 ms  …    20.1 ms
  Memory         6.9 MiB ±     0.0 MiB      6.8 MiB …     6.9 MiB
 
Benchmark 2: Optimized (work/R05-T035/fast.sh) (305 runs)
                mean     ±       σ          min     …     max
  Wall Time      9.7 ms  ±     0.3 ms       9.2 ms  …    10.5 ms           -49.2%  (2.0x faster)
  Memory         6.8 MiB ±     0.0 MiB      6.8 MiB …     6.9 MiB           -0.6%
```

#### Markdown Export Table (`work/R05-T035/hyperfine_benchmark.md`)
| Command | Mean Wall Time [ms] | Change | Factor |
|:---|---:|---:|:---|
| `Original (.meta/example.sh)` | 19.1 ± 0.4 | | |
| `Optimized (work/R05-T035/fast.sh)` | 9.7 ± 0.3 | -49.2% | (2.0x faster) |

> **Note on Process Startup Overhead**:
> Measuring a no-op Bash invocation (`bash -c "exit 0"`) on macOS arm64 reveals a fixed interpreter process startup time of ~6.6 ms.
> Subtracting startup latency ($19.1 - 6.6 = 12.5\text{ ms}$ vs. $9.7 - 6.6 = 3.1\text{ ms}$):
> **Pure Bash algorithm execution time improved by ~4.0x (12.5 ms down to 3.1 ms)!**

---

### Bats Timing Comparison (`bats --timing`)

#### Baseline Timing (`work/R05-T035/bats_timing_baseline.txt`)
```text
1..5
ok 1 no primes under two in 27ms
ok 2 find first prime in 22ms
ok 3 find primes up to 10 in 18ms
ok 4 limit is prime in 20ms
ok 5 find primes up to 1000 in 35ms
```

#### Optimized Timing (`work/R05-T035/bats_timing_optimized.txt`)
```text
1..5
ok 1 no primes under two in 18ms
ok 2 find first prime in 16ms
ok 3 find primes up to 10 in 17ms
ok 4 limit is prime in 17ms
ok 5 find primes up to 1000 in 21ms
```

- **Test 5 (`find primes up to 1000`) Wall Time:** Reduced from **35ms** to **21ms** (a **40.0% reduction** in test runner time).
- **Total Bats Suite Duration:** Reduced from **122ms** to **89ms** (a **27.0% overall test suite speedup**).

---

## Verification & Track Checks

1. **Test Suite Verification (`bin/validate_one_exercise`):**
   - Executed `bin/validate_one_exercise exercises/practice/sieve`.
   - Result: All 5/5 tests pass (`work/R05-T035/validator_log.txt`).
2. **Static Analysis (`shellcheck -o all`):**
   - Executed `shellcheck -o all exercises/practice/sieve/.meta/example.sh`.
   - Result: 0 warnings, 0 style notes (`work/R05-T035/final_shellcheck.txt`).
3. **Metadata & Track Sync (`bin/configlet sync -e sieve`):**
   - Executed `bin/configlet sync -e sieve`.
   - Result: "The `sieve` exercise has up-to-date docs, filepaths, metadata, and tests!" (`work/R05-T035/configlet_sync.txt`).
4. **Clean Working Tree:**
   - The user stub file `exercises/practice/sieve/sieve.sh` remains untouched and identical to `main`.
