# Task R05-T032: Create `.meta/template.j2` for `simple-cipher`

## Goal
Implement `.meta/template.j2` for `simple-cipher` so its 16 Bats tests can be regenerated from canonical data while preserving random-key tests and Bash-specific tests.

## Changes Made
1. **`exercises/practice/simple-cipher/.meta/template.j2`**:
   - Created Jinja2 template handling both canonical data cases (random-key cipher and substitution cipher) and Bash-specific cases.
   - Structured tests to generate "Can generate a random key" as the first test with the commented-out skip directive (`# [[ $BATS_RUN_SKIPPED == "true" ]] || skip`).
   - All subsequent 15 tests have the active skip directive (`[[ $BATS_RUN_SKIPPED == "true" ]] || skip`), ensuring exactly 1 commented skip directive in the file.
   - Protected Bash syntax `${#key}` and `${#output}` from Jinja2 comment interpretation using `{% raw %}` blocks.
   - Preserved random-key test structure and assertions.

2. **`exercises/practice/simple-cipher/simple_cipher.bats`**:
   - Regenerated via `python3 bin/generate_tests --no-pull simple-cipher`.
   - Produces all 16 tests identically matching original assertions, variables, and logic.

## Validation Results
- `bin/validate_one_exercise exercises/practice/simple-cipher`: All 16 tests pass with `example.sh`.
- Exactly 1 commented skip directive detected by validator.
- Without `BATS_RUN_SKIPPED=true`, only test 1 runs and tests 2-16 are skipped.
- `bin/configlet sync -e simple-cipher`: Up-to-date docs, filepaths, metadata, and tests.

