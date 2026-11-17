# R05-T055 — Speed up the `prime-factors` example

**Student:** Harshit Dhablia (E26B07F1068)  
**Task:** R05-T055 · 5 of 10  
**Issue:** https://github.com/S-AI-Projects/bash/issues/55  
**Exercise:** `exercises/practice/prime-factors/`  

---

## 1. Initial Test Timings (`bats --timing`)

Running all 12 tests against the original example stub:

```text
1..12
ok 1 no factors in 8ms
ok 2 prime number in 8ms
ok 3 another prime number in 8ms
ok 4 square of a prime in 8ms
ok 5 product of first prime in 8ms
ok 6 cube of a prime in 8ms
ok 7 product of second prime in 8ms
ok 8 product of third prime in 8ms
ok 9 product of first and second prime in 8ms
ok 10 product of primes and non-primes in 8ms
ok 11 product of primes in 7ms
ok 12 factors include a large prime in 19ms
```

**Slowest test:** Test 12 ("factors include a large prime", input `93819012551`, expected `11 9539 894119`), taking **19ms**.

---

## 2. Bottleneck Analysis

In the original algorithm:
```bash
while (( p * p <= n )); do
    if (( n % p == 0 )); then
        factors+=( $p )
        (( n /= p ))
    else
        (( p += 1 ))
    fi
done
```
- Incrementing by 1 (`p += 1`) causes the loop to test all even numbers (`4, 6, 8, 10, ...`) even after 2 was already completely factored out.
- For `93819012551`, after extracting 11, the remaining cofactor is `8529001141`. The next factor is `9539`.
- Testing every integer between 12 and 9539 requires 9,527 iterations, roughly half of which test even candidates pointlessly.

---

## 3. Optimisation Implemented (`work/R05-T055/fast.sh`)

1. **Extract all factors of 2 first:**
   ```bash
   while (( n % 2 == 0 )); do
     factors+=( 2 )
     (( n /= 2 ))
   done
   ```
2. **Step by 2 for odd candidates starting at 3:**
   ```bash
   local -i p=3
   while (( p * p <= n )); do
     if (( n % p == 0 )); then
       factors+=( "${p}" )
       (( n /= p ))
     else
       (( p += 2 ))
     fi
   done
   ```
3. **Stop trial division at $\sqrt{n}$:** Condition `(( p * p <= n ))` halts candidate testing as soon as $p > \sqrt{n}$. Any remaining $n > 1$ is guaranteed to be prime.
4. **Google Shell Style Guide:** Wrapped inside `main()`, scoped with `local -i` and `local -a`, and compliant with `shellcheck -o all`.

---

## 4. Hyperfine Benchmark Results

Benchmark on the slowest test input (`93819012551`):

```text
Benchmark 1: bash exercises/practice/prime-factors/.meta/example.sh 93819012551 (207 runs)
                   mean ±     σ    min …   max
  Wall Time [ms]   15.0 ±   0.6   14.1 …  21.5
  Memory [MiB]      6.7 ±   0.0    6.7 …   6.8
 
Benchmark 2: bash work/R05-T055/fast.sh 93819012551 (319 runs)
                   mean ±     σ    min …   max
  Wall Time [ms]    9.4 ±   0.6    8.8 …  19.5   -37.1%  (1.6x faster)
  Memory [MiB]      6.7 ±   0.0    6.7 …   6.8    +0.5%
```

- **Wall time reduced from 15.0 ms to 9.4 ms (1.6x speedup, ~37% faster).**

---

## 5. Verification & Validation Results

| Check | Command | Result |
|---|---|---|
| ShellCheck (all checks) | `shellcheck -o all exercises/practice/prime-factors/.meta/example.sh` | **Clean (0 errors, 0 warnings, exit 0)** |
| Diff Check | `git diff --check` | **Clean (exit 0)** |
| Exercise Validator | `bin/validate_one_exercise exercises/practice/prime-factors` | **12/12 tests passed (exit 0)** |
| Configlet Lint | `bin/configlet lint` | **Clean** (only pre-existing track-wide `docs/SIGN_UP_SNIPPET.txt`) |
| Correctness | All 12 canonical tests | **100% identical outputs** |
