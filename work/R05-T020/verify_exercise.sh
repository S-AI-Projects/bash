#!/usr/bin/env bash
# Verification script for saddle-points exercise
set -euo pipefail

export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:/opt/homebrew/opt/grep/libexec/gnubin:$PWD/bin:$PATH"

echo "=== 1. ShellCheck Verification ==="
shellcheck -o all \
    exercises/practice/saddle-points/.meta/example.sh \
    exercises/practice/saddle-points/saddle_points.sh
echo "ShellCheck: PASS (0 warnings)"

echo
echo "=== 2. Configlet Lint ==="
bin/configlet lint || true

echo
echo "=== 3. Exercise Validation (bin/validate_one_exercise) ==="
bin/validate_one_exercise exercises/practice/saddle-points
