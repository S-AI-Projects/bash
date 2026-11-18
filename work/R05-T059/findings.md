# Task R05-T059: Friendlier Generator Error — Investigation & Findings

## 1. Overview & Context

- **Task ID:** R05-T059
- **Issue:** [S-AI-Projects/bash#59](https://github.com/S-AI-Projects/bash/issues/59)
- **Student:** Harshit Dhablia (E26B07F1068)
- **Working Branch:** `student/e26b07f1068/R05-T059`
- **Target Repository:** `S-AI-Projects/bash`

---

## 2. Investigation of Repository Scripts

As required by Step 1 of Issue #59, the key scripts were inspected:

1. **`bin/generate_tests`:**
   - Python generator script that parses test case data from `problem-specifications/exercises/<exercise>/canonical-data.json`, matches cases against `.meta/tests.toml`, and renders test files via Jinja2 (`.meta/template.j2`).
   - Uses `problem_spec_dir()` to detect the specifications directory, first in `$XDG_CACHE_HOME/exercism/configlet/problem-specifications` (or `~/.cache/...`), then in parent directories.
   - Previously raised an unhandled `LookupError("Could not find problem specs")` when the directory was not found.
   - Contained an unused `import sys` on line 13 that triggered linter warnings.

2. **`bin/validate_one_exercise`:**
   - Bash script that validates an individual practice or concept exercise by ensuring required files (`.meta/config.json`, stub, tests, solution) exist, checking the commented-out `skip` directive count, copying the reference solution to the stub, running `bats "${tests}"`, and cleaning up using a `git checkout "${stub}"` trap.

3. **`bin/validate_exercises`:**
   - Loops over every exercise under `exercises/*/*` and executes `bin/validate_one_exercise` for each.

4. **`.github/scripts/ci`:**
   - Invokes `bin/validate_exercises` in CI environments.

5. **`.github/scripts/pr`:**
   - Given a list of modified files in a PR, extracts unique exercise directories and runs `bin/validate_one_exercise` for each changed exercise.

---

## 3. The Original Problem

When `problem-specifications` was not present in the cache or parent directories, running `bin/generate_tests` caused an unhandled `LookupError` traceback:

```text
$ HOME=$(mktemp -d) bin/generate_tests bob
Traceback (most recent call last):
  File "/Users/harshitdhablia/bash/bin/generate_tests", line 195, in <module>
    main()
    ~~~~^^
  File "/Users/harshitdhablia/bash/bin/generate_tests", line 165, in main
    specs = problem_spec_dir()
  File "/Users/harshitdhablia/bash/bin/generate_tests", line 30, in problem_spec_dir
    raise LookupError("Could not find problem specs")
LookupError: Could not find problem specs
```

This traceback:
- Confused contributors by looking like a generator code crash rather than a missing dependency.
- Provided no guidance on how to obtain `problem-specifications`.
- Left `import sys` unused, causing `ruff check` to fail with `F401`.

---

## 4. Change Implemented

In `bin/generate_tests`, `main()` was updated to catch `LookupError` when locating `problem-specifications`. Instead of letting the traceback crash the script, it now writes a clear, actionable guide to `sys.stderr` and terminates with status code `1`:

```python
def main():
    """Main entrypoint."""
    try:
        specs = problem_spec_dir()
    except LookupError:
        print(
            "Could not find problem-specifications repository.\n"
            "You can fetch it using configlet:\n"
            "    bin/configlet sync\n"
            "or by cloning the repository:\n"
            "    git clone https://github.com/exercism/problem-specifications",
            file=sys.stderr,
        )
        sys.exit(1)
    args = argparser().parse_args()
```

---

## 5. Demonstration & Test Results

### A. Missing `problem-specifications` Demo (Empty `$HOME`)

Command:
```bash
HOME=$(mktemp -d) bin/generate_tests bob
```

Output:
```text
Could not find problem-specifications repository.
You can fetch it using configlet:
    bin/configlet sync
or by cloning the repository:
    git clone https://github.com/exercism/problem-specifications
```

Exit status: `1` (Verified with `echo $?`). Traceback: None.

### B. Problem Specifications Present

Command:
```bash
bin/generate_tests --no-pull bob
```

Output:
- Exit status: `0`
- `git diff exercises/practice/bob`: Clean (no modifications to generated tests when up to date).

### C. Python Linting with `ruff`

Command:
```bash
python3 -m ruff check bin/generate_tests
```

Output:
```text
All checks passed!
```

Exit status: `0`. The unused `sys` import warning is fully resolved.

### D. Exercise Validation on `bob`

Command:
```bash
PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH" bin/validate_one_exercise exercises/practice/bob
```

Output:
```text
Processing bob
1..29
ok 1 asking a question
ok 2 shouting
ok 3 forceful question
ok 4 silence
ok 5 stating something
ok 6 asking a numeric question
ok 7 asking gibberish
ok 8 question with no letters
ok 9 non-letters with question
ok 10 prattling on
ok 11 ending with whitespace
ok 12 multiple line question
ok 13 shouting gibberish
ok 14 shouting a statement containing a question mark
ok 15 shouting numbers
ok 16 shouting with special characters
ok 17 shouting with no exclamation mark
ok 18 prolonged silence
ok 19 alternate silence
ok 20 other whitespace
ok 21 talking forcefully
ok 22 using acronyms in regular speech
ok 23 no letters
ok 24 statement containing question mark
ok 25 starting with whitespace
ok 26 non-question ending with whitespace
ok 27 no input is silence
ok 28 yelling a filename expansion
ok 29 asking a filename expansion
```

Exit status: `0`. All 29 unit tests pass.

---

## 6. Summary of Acceptance Criteria

| Criteria | Status | Evidence |
|---|---|---|
| Prints how to fetch problem specs when missing and exits 1 (no traceback) | ✅ Passed | Tested with empty `$HOME`; printed clear message, exited 1 |
| Demo on `exercises/practice/bob` shows new message | ✅ Passed | Demonstrated via `HOME=$(mktemp -d) bin/generate_tests bob` |
| With specs present, generating `bob` is unchanged | ✅ Passed | `bin/generate_tests --no-pull bob` exited 0 with no diff |
| `ruff` passes on `bin/generate_tests` | ✅ Passed | `python3 -m ruff check bin/generate_tests` reports "All checks passed!" |
