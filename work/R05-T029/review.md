# R05-T029 — Run ShellCheck in Validator

## Summary

Enhanced `bin/validate_one_exercise` to optionally run ShellCheck on `.meta/example.sh`:
- Runs `shellcheck "${solution}"` when the `shellcheck` executable is available in `$PATH`.
- Reports warnings if ShellCheck finds issues without failing the validator prematurely, allowing existing exercise suites to complete (`bin/validate_exercises`).
- Prints a clear skip message (`ShellCheck is not installed, skipping ShellCheck validation`) when `shellcheck` is absent.

## Verification

- `shellcheck bin/validate_one_exercise bin/validate_exercises .github/scripts/ci` — PASSED with 0 warnings.
- `bin/validate_one_exercise exercises/practice/darts` — PASSED with ShellCheck output displayed.
- Documented before/after demonstration on `exercises/practice/darts` in `work/R05-T029/demo.md`.
