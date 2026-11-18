<!-- markdownlint-disable MD013 -->
# Task R05-T039: Make validate_exercises report all failures (Issue #41)

## Overview & Objectives

Currently `bin/validate_exercises` stops at the first failure (`set -o errexit`). When an exercise fails, the validation loop halts immediately, leaving the remaining exercises untested and providing no failure summary.

This task updates `bin/validate_exercises` in accordance with `POLICIES.md` and the Google Shell Style Guide so that it:

1. Validates every exercise in the track without aborting prematurely on failure.
2. Tracks passed count (`passed`), failed count (`failed`), and the names of all failing exercises.
3. Prints a clear `'N passed, M failed'` summary at the end, listing failing exercise names when `failed > 0`.
4. Exits with code `0` when all exercises pass, and exits non-zero (`1`) when any exercise fails.

---

## 1. Documentation of Existing Scripts

### `bin/validate_one_exercise`

- **Purpose:** Validates test execution and example implementation for a single exercise directory passed as `$1`.
- **Key Operations:**
  - Changes directory to `$1` and verifies `.meta/config.json`.
  - Reads filenames for solution stub, tests, and example from `.meta/config.json`.
  - Checks that the test file has the expected number of commented-out skip directives (`hello-world`: 0, all others: 1) using `grep -cP`.
  - Registers an `EXIT` trap to restore the user stub file via `git checkout "${stub}"`.
  - Copies `.meta/example.sh` to the stub file.
  - Runs Bats tests with `BATS_RUN_SKIPPED=true bats "${tests}"`.
  - Exits `0` on success or non-zero on failure.

### `bin/validate_exercises` (Original)

- **Purpose:** Bulk runner intended to test all exercises in the repository.
- **Key Operations:**
  - Moves to repo root: `cd "$( dirname "${BASH_SOURCE[0]}" )/.."`.
  - Sets `set -o errexit` and `set -o nounset`.
  - Iterates over `exercises/*/*` calling `bin/validate_one_exercise "$exercise"`.
  - **Limitation:** Due to `errexit`, the script halts immediately on the first failure. Exercises occurring alphabetically after the failure are never run, and no failure tally or list of failed exercises is produced.

### `bin/generate_tests`

- **Purpose:** Test generator written in Python 3 (`generate_tests`).
- **Key Operations:**
  - Locates problem specifications in cache or parent directories.
  - Parses canonical test cases from `canonical-data.json` and filters/overrides them based on `.meta/tests.toml`.
  - Uses Jinja2 (`.meta/template.j2`) to render Bats test files.
  - Preserves unchanged test suites and writes new/updated Bats test files formatted for the Bash track.

### `.github/scripts/ci`

- **Purpose:** CI workflow entrypoint for push and scheduled events on the track repository.
- **Key Operations:**
  - Simple wrapper executing `bin/validate_exercises` to run track-wide validation.

### `.github/scripts/pr`

- **Purpose:** CI workflow entrypoint for pull requests.
- **Key Operations:**
  - Accepts a list of modified/added files as arguments.
  - Extracts unique exercise paths matching `exercises/(practice|concept)/<slug>`.
  - Validates only touched exercises using `bin/validate_one_exercise "$dir" || status=1`.
  - Notably continues running remaining touched exercises upon failure, exiting with the aggregated exit status `$status`.

---

## 2. Before-Change Scratch Demo on `exercises/practice/sublist`

Before modifying `bin/validate_exercises`, an intentional failure was injected into `exercises/practice/sublist/.meta/example.sh` (`result() { echo "BROKEN"; exit 1; }`).

### Before-Change Execution & Behavior

- Executed `bin/validate_exercises` (recorded in `work/R05-T039/before_break_sublist.txt`).
- The script processed exercises alphabetically up to `sublist` (exercise 88 of 100).
- When `sublist` failed, the script aborted immediately due to `errexit`.
- **Remaining exercises skipped:** Exercises 89–100 (`sum-of-multiples`, `swift-scheduling`, `tournament`, `transpose`, `triangle`, `twelve-days`, `two-bucket`, `two-fer`, `variable-length-quantity`, `word-count`, `wordy`, `yacht`) were never executed.
- No pass/fail summary was printed.
- Exit code was `1`.
- `exercises/practice/sublist` was immediately restored via `git checkout -- exercises/practice/sublist`.

---

## 3. Updated `bin/validate_exercises` Implementation

`bin/validate_exercises` was updated following the Google Shell Style Guide and `POLICIES.md`:

```bash
#!/usr/bin/env bash
#
# Validate if tests can run properly and the example implementation
# is passing the tests for each exercise.

set -o errexit
set -o nounset

main() {
  local -i passed=0 failed=0
  local -a failed_exercises=()
  local exercise exercise_name

  cd "$( dirname "${BASH_SOURCE[0]}" )/.." || exit 1

  for exercise in exercises/*/*; do
    exercise_name="${exercise##*/}"
    if bin/validate_one_exercise "${exercise}"; then
      (( passed += 1 ))
    else
      (( failed += 1 ))
      failed_exercises+=("${exercise_name}")
    fi
    echo
  done

  echo "${passed} passed, ${failed} failed"
  if (( failed > 0 )); then
    echo "Failed exercises:"
    for exercise_name in "${failed_exercises[@]}"; do
      echo "  - ${exercise_name}"
    done
    return 1
  fi

  return 0
}

main "$@"
```

### Static Analysis

- Ran `shellcheck -o all bin/validate_exercises` (output in `work/R05-T039/shellcheck.txt`).
- **Result:** 0 warnings, 0 errors, 0 style notes.

---

## 4. After-Change Scratch Demo on `exercises/practice/sublist`

The same scratch break was introduced into `exercises/practice/sublist/.meta/example.sh`.

### After-Change Execution & Behavior

- Executed updated `bin/validate_exercises` (recorded in `work/R05-T039/after_break_sublist.txt`).
- The script encountered the failure on `sublist`, recorded the failure, and **continued** executing all remaining exercises through `yacht` (exercise 100).
- Summary printed at completion:

  ```text
  99 passed, 1 failed
  Failed exercises:
    - sublist
  ```

- Exit code was `1`.
- `exercises/practice/sublist` was restored immediately, confirmed with `git diff exercises/` (clean).

---

## 5. Full Pass Verification (Clean Working Tree)

Ran `bin/validate_exercises` with clean exercises (recorded in `work/R05-T039/full_pass.txt`):

- All 100 exercises executed and passed.
- Summary printed:

  ```text
  100 passed, 0 failed
  ```

- Exit code was `0`.
