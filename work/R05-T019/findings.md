# Task R05-T019 Findings: Check tests.toml Coverage in Validator

## 1. Overview and Analysis of Existing Scripts

A survey of the repository's test and validation tooling was conducted:

- **`bin/validate_one_exercise`**: Validates a single exercise directory. Ensures stub, test, and example files exist, checks for the expected count of commented skip directives, executes the test suite with `BATS_RUN_SKIPPED=true` using the example implementation, and restores the stub via `git checkout`.
- **`bin/validate_exercises`**: Iterates across all exercises in `exercises/*/*`, running `bin/validate_one_exercise` on each.
- **`bin/generate_tests`**: Python-based generator utilizing Jinja2 templates (`.meta/template.j2`) and canonical data (`canonical-data.json`, `.meta/tests.toml`) to produce test files (`.bats`).
- **`.github/scripts/ci`**: CI runner script executing configlet linting, shellcheck, formatting checks, and exercise validation across the repository.
- **`.github/scripts/pr`**: Pull request workflow script determining modified exercises and running targeted validations.

## 2. Implementation: tests.toml Test Coverage Check

`bin/validate_one_exercise` was extended to check canonical test coverage against `.meta/tests.toml`:
1. If `.meta/tests.toml` exists in the exercise directory, it is parsed using `awk` to extract all test cases where `include = false` is not set.
2. For each canonical test description:
   - Check if the full description or trailing canonical description (`${desc##* -> }`) exists in the test file (`$tests`).
   - If not found, a descriptive warning is printed:
     `warning: ${exercise} test not found in ${tests}: ${desc}`
3. Exercises without `.meta/tests.toml` (such as `error-handling`) cleanly bypass the check without error.
4. Track-specific tests not present in canonical problem-specifications (such as `house` tests `invalid verse 1` through `invalid verse 4`) are not in `tests.toml` and are therefore never flagged.

## 3. Verification & Results

### 3.1 Verification on `exercises/practice/house`
Running `bin/validate_one_exercise exercises/practice/house` emits 0 warnings:
- All 14 canonical tests match descriptions in `house.bats`.
- The 4 track-specific error tests (`invalid verse 1` to `invalid verse 4`) are not flagged.

### 3.2 Scratch Copy Demonstration
In `work/R05-T019/demo_warning.sh`, a scratch copy of `exercises/practice/house` was created, and `@test "full rhyme"` was deliberately renamed to `@test "deliberately renamed rhyme"`.
Running the validator immediately outputs:
```
warning: house test not found in house.bats: full rhyme
```
Full demonstration log is captured in `work/R05-T019/demo_warning.log`.

### 3.3 Whole Track Validation
The whole track was validated using `bin/validate_exercises > work/R05-T019/track_validation.log 2>&1`.
The check completed successfully across all exercises, surfacing existing canonical test drift in exercises such as:
- `darts`: Canonical description has UK spelling `centre` while bash test uses US spelling `center`.
- `grains`: Canonical description specifies `raises an exception` while bash test specifies `raises an error`.
- `beer-song`, `robot-simulator`, `diffie-hellman`: Hand-written test suites with customized descriptions differing from problem-specifications.

### 3.4 ShellCheck
Passed with zero warnings:
```bash
shellcheck bin/validate_one_exercise bin/validate_exercises .github/scripts/ci
```
