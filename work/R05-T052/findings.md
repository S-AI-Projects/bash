# Task Evidence & Findings: Create `.meta/template.j2` for `grep`

- **Task ID:** R05-T052
- **Assigned Issue:** https://github.com/S-AI-Projects/bash/issues/52
- **Student Name:** Harshit Dhablia
- **Enrollment Number:** E26B07F1068
- **Working Branch:** `student/e26b07f1068/R05-T052`
- **Exercise Directory:** `exercises/practice/grep/`

---

## 1. Objective & Canonical Investigation

### Goal
The `grep` practice exercise previously had no test generation template (`.meta/template.j2`), preventing its 25 Bats tests from being regenerated or updated when canonical problem specifications change. The objective was to create `.meta/template.j2` so that running `python3 bin/generate_tests --no-pull grep` reproduces the existing test suite identically.

### Canonical Data Analysis
Inspection of `problem-specifications/exercises/grep/canonical-data.json`:
- Contains 25 test cases across two test groups:
  1. *Test grepping a single file* (Cases 1–14)
  2. *Test grepping multiple files at once* (Cases 15–25)
- Inputs provide:
  - `pattern`: Target string/regular expression.
  - `flags`: List of flags (`-n`, `-l`, `-i`, `-v`, `-x`).
  - `files`: Target file list (`iliad.txt`, `midsummer-night.txt`, `paradise-lost.txt`).
- `expected`: A list of strings representing the expected output lines.

---

## 2. Template Architecture & Implementation

### Template Details (`exercises/practice/grep/.meta/template.j2`)
1. **Header:** Uses `{{ header }}` supplied by `bin/generate_tests` to output the standard Bats shebang, `load bats-extra`, and ISO-8601 generation timestamp.
2. **Setup and Teardown:**
   - Reproduces `setup()` creating the three test files (`iliad.txt`, `midsummer-night.txt`, `paradise-lost.txt`) with exact text from the original test file.
   - Reproduces `teardown()` removing the three fixture files.
3. **Test Generation Loop:**
   - Iterates through `cases` using `{% for case in cases %}`.
   - Comments out the skip directive on the first test: `{% if loop.first %}#{% endif %}[[ $BATS_RUN_SKIPPED == "true" ]] || skip`.
   - Joins expected lines using `{{ case["expected"] | join("\n") }}`.
   - Populates flags and files arrays:
     `flags=({% for f in case["input"]["flags"] %}{{ f }}{% if not loop.last %} {% endif %}{% endfor %})`
     `files=({{ case["input"]["files"] | join(" ") }})`
   - Executes `run bash {{ solution }} "${flags[@]}" "$pattern" "${files[@]}"`.
   - Checks assertions: `assert_success` and `assert_output "$expected"`.
   - Perfectly handles whitespace and section headers (`# Test grepping a single file` and `# Multiple files`).

---

## 3. Verification & Validation Commands

1. **Test Generation & Diff Check:**
   ```bash
   python3 bin/generate_tests --no-pull grep
   git diff --exit-code -I '^# generated on' exercises/practice/grep/grep.bats
   ```
   - **Result:** Exit code `0`. All 25 canonical test cases generated with 0 diff lines (apart from the updated timestamp line).

2. **Exercise Validation:**
   ```bash
   bin/validate_one_exercise exercises/practice/grep
   ```
   - **Result:** Exit code `0`. All 25 tests passed:
   ```text
   Processing grep
   1..25
   ok 1 One file, one match, no flags
   ok 2 One file, one match, print line numbers flag
   ok 3 One file, one match, case-insensitive flag
   ok 4 One file, one match, print file names flag
   ok 5 One file, one match, match entire lines flag
   ok 6 One file, one match, multiple flags
   ok 7 One file, several matches, no flags
   ok 8 One file, several matches, print line numbers flag
   ok 9 One file, several matches, match entire lines flag
   ok 10 One file, several matches, case-insensitive flag
   ok 11 One file, several matches, inverted flag
   ok 12 One file, no matches, various flags
   ok 13 One file, one match, file flag takes precedence over line flag
   ok 14 One file, several matches, inverted and match entire lines flags
   ok 15 Multiple files, one match, no flags
   ok 16 Multiple files, several matches, no flags
   ok 17 Multiple files, several matches, print line numbers flag
   ok 18 Multiple files, one match, print file names flag
   ok 19 Multiple files, several matches, case-insensitive flag
   ok 20 Multiple files, several matches, inverted flag
   ok 21 Multiple files, one match, match entire lines flag
   ok 22 Multiple files, one match, multiple flags
   ok 23 Multiple files, no matches, various flags
   ok 24 Multiple files, several matches, file flag takes precedence over line number flag
   ok 25 Multiple files, several matches, inverted and match entire lines flags
   ```

3. **Track Linting Check:**
   ```bash
   bin/configlet lint
   ```
   - **Result:** Exercise passed linting. (Pre-existing track documentation gap `docs/SIGN_UP_SNIPPET.txt` noted).

---

## 4. Files Changed

- `exercises/practice/grep/.meta/template.j2`: Added the missing Jinja2 test generator template.
- `exercises/practice/grep/grep.bats`: Regenerated using the new template (only the header timestamp line updated).
- `work/R05-T052/findings.md`: Added task documentation and validation results.
