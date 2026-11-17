# R05-T053 — Mutation-driven test gap in `ocr-numbers`

**Student:** Harshit Dhablia (E26B07F1068)
**Task:** R05-T053 · 3 of 10
**Issue:** https://github.com/S-AI-Projects/bash/issues/53

## 1. Coverage gap identified

The existing 18 tests include only **one** test for the row-count error path:
a 3-line input (test "Input with a number of lines that is not a multiple of
four").  Three is an **odd** number, so a mutation that weakens the check from
`% 4` to `% 2` still rejects 3 lines (3 % 2 = 1 ≠ 0) and all valid inputs
(4, 8, 12 lines) remain multiples of 2.  The mutant survives — every test
still passes.

## 2. Mutants tested

| # | File | Mutation | Target | Result |
|---|------|----------|--------|--------|
| 1 | mutant1.sh | `% 4` → `% 2` in row check | Row check | **SURVIVED** |
| 2 | mutant2.sh | `!= 0` → `== 0` in row check | Row check | KILLED |
| 3 | mutant3.sh | Remove row check entirely | Row check | KILLED |
| 4 | mutant4.sh | `!= 0` → `== 0` in column check | Column check | KILLED |
| 5 | mutant5.sh | Remove column check entirely | Column check | KILLED |
| 6 | mutant6.sh | `exit 1` → `exit 0` in row error | Row check | KILLED |
| 7 | mutant7.sh | Remove `:-"?"` fallback for garbled digits | Digit mapping | KILLED |

7 mutants total, 5 targeting row/column checks (exceeds minimum of 3).

## 3. New test added

**Test name:** "Input with two lines does not have a valid number of lines"

**Input (2 lines via heredoc):**
```
 _
| |
```

**Expected:** `assert_failure` with message
"Number of input lines is not a multiple of four"

**Why this kills mutant1:** 2 % 2 = 0 → the mutant accepts the input, but
the test expects failure → `assert_failure` fails → mutant killed.

## 4. Implementation

- **Changed:** `exercises/practice/ocr-numbers/.meta/template.j2`
  — appended a new track-only `@test` block after the existing "No input" test
- **Regenerated:** `exercises/practice/ocr-numbers/ocr_numbers.bats`
  — now has 19 tests (was 18)

No changes to `example.sh` or `tests.toml`.

## 5. Validation results

| Check | Result |
|-------|--------|
| `python3 bin/generate_tests --no-pull ocr-numbers` | ✅ exit 0 |
| `git diff --exit-code -I '^# generated on' …/ocr_numbers.bats` | ✅ exit 0 |
| `bin/validate_one_exercise exercises/practice/ocr-numbers` | ✅ 19/19 tests pass |
| `bin/configlet lint` | ⚠ pre-existing `SIGN_UP_SNIPPET.txt` only |
| `bash work/R05-T053/run_mutants.sh` (before new test) | 6 killed, **1 survived** |
| `bash work/R05-T053/run_mutants.sh` (after new test) | **7 killed, 0 survived** |
