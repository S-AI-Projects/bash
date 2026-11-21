# R05-T049 — Findings: Add a --check mode to the test generator

Student: Hemant Gandhe (E26B07F0874)
Task: R05-T049, Issue 50 in S-AI-Projects/bash
Branch: R05-T049, from main 9567ba5
Test case: exercises/practice/run-length-encoding

## What each script does (read first)

- `bin/generate_tests` (Python): renders each exercise's `.bats` test file from its `.meta/template.j2`, using cases from problem-specifications `canonical-data.json` filtered by `.meta/tests.toml`. It ignores the `# generated on <timestamp>` line when comparing, so a re-render with no real change writes nothing.
- `bin/validate_one_exercise` (bash): copies `.meta/example.sh` over the stub, runs `bats` on the exercise's test file, then restores the stub with `git checkout`.
- `bin/validate_exercises` (bash): runs `bin/validate_one_exercise` for every exercise under `exercises/*/*`.
- `.github/scripts/ci` (bash): just runs `bin/validate_exercises`.
- `.github/scripts/pr` (bash): for each file changed in a PR, extracts the exercise directory and runs `bin/validate_one_exercise` on it once.

## Change

Only `bin/generate_tests` changed (37 insertions, 6 deletions).

- Split the old `generate()` into `render_test()` (render only, no writing) and `test_file_path()` (the generated `.bats` path from `.meta/config.json`), plus a new `generate(..., check=False) -> bool` that returns True if the committed file is up to date, False otherwise, and never writes in check mode.
- Added `--check` to the argument parser. In `main()`, when `--check` is given, every out-of-date exercise's `.bats` path is collected and printed, one per line, and the script exits 1 if any were found, 0 otherwise.
- The comparison still ignores the `# generated on` timestamp line, so a clean re-render is not reported as out of date. A missing test file also counts as out of date.
- No change to behaviour without `--check`: it still renders and writes only when the content (ignoring the timestamp) differs.

`sys` was already imported but unused (ruff F401 on clean main). Using `sys.exit(1)` in the new `--check` path makes that import used, so ruff now passes. No other import was added.

## Demo (run-length-encoding)

Full output: `check-demo.txt` in this folder.

- `bin/generate_tests --no-pull --check run-length-encoding` on a clean tree → exit 0, no output.
- Hand edit: appended `# hand edit for --check demo` to `exercises/practice/run-length-encoding/run_length_encoding.bats` → `--check run-length-encoding` printed `exercises/practice/run-length-encoding/run_length_encoding.bats` and exited 1. The file was not rewritten by `--check`.
- Reverted the hand edit with `git checkout -- ...` → `--check run-length-encoding` exit 0 again.
- `--check` on several exercises (`run-length-encoding atbash-cipher crypto-square acronym`) → exit 0.
- `--check` with no exercise arguments (all exercises with templates) → exit 0.
- `bin/generate_tests --no-pull` on the same several exercises, without `--check` → exit 0, no files changed (`git status` clean apart from `bin/generate_tests`).

## Checks

- `python3 -m ruff check bin/generate_tests` → "All checks passed!" (exit 0). Before this change it failed with F401 `sys` imported but unused; that import is now used by `sys.exit(1)`.
- `bin/validate_one_exercise exercises/practice/run-length-encoding` → 13/13 tests pass (exit 0).
- `shellcheck bin/validate_one_exercise bin/validate_exercises .github/scripts/ci` → exit 1, one info-level SC2016 in `bin/validate_one_exercise` line 34 (`$BATS_RUN_SKIPPED` in single quotes). This is pre-existing: the same check on clean `main` (with this change stashed) also exits 1 with the same message. This change does not touch any shell script, so it was left alone.
- `bin/generate_tests --no-pull --check` (all) → exit 0, confirming no committed `.bats` file was changed by the refactor.
- Setup note: problem-specifications was not in the cache, so it was cloned to `~/.cache/exercism/configlet/problem-specifications`, and `jinja2` + `ruff` were installed with pip (`--break-system-packages`). `bats` and `shellcheck` were installed via apt during Task 8.

## PR

- Base: S-AI-Projects/bash, head: HemantAsur/bash:R05-T049 (branch `R05-T049`)
- Commit the code change (`bin/generate_tests`) plus this `work/R05-T049/` folder.
- For a later upstream PR, create a second branch containing only the code change (no `work/` folder).
- Upstream note from the issue: discuss the change first on forum.exercism.org (Bash category) and link the thread — maintainers close undiscussed PRs.
