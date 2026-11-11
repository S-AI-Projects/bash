# R05-T025 — Baseline Benchmark

## Environment
- OS: macOS (Apple Silicon)
- Bash: 5.3.20
- Bats: 1.14.0
- Hyperfine: 2.0.0
- GNU Coreutils paste: 9.12

## Original implementation
- File: exercises/practice/change/.meta/example.sh
- Test suite: 13/13 passed
- Slowest test: large target values (target = 999)
- Bats timing: 84 ms

## Hyperfine benchmark
Command:
`/opt/homebrew/bin/bash change.sh 999 1 2 5 10 20 50 100`

- Runs: 10
- Warmups: 3
- Mean: 75.9 ms
- Standard deviation: 2.7 ms
- Minimum: 73.3 ms
- Maximum: 83.1 ms
- Memory: 6.9 MiB

Note: This is a local macOS benchmark, not a Linux benchmark.
