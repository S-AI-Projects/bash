# Task Evidence & Findings: Knapsack Test Exclusion Investigation

- **Task ID:** R05-T051
- **Assigned Issue:** https://github.com/S-AI-Projects/bash/issues/6
- **Student Name:** Harshit Dhablia
- **Enrollment Number:** E26B07F1068
- **Working Branch:** `student/e26b07f1068/R05-T051`
- **Exercise Directory:** `exercises/practice/knapsack/`

---

## 1. Objective & Canonical Investigation

### Canonical Test Cases for "no items"
Inspection of `problem-specifications/exercises/knapsack/canonical-data.json` shows two test cases with the description `"no items"`:

1. **Original Canonical Case (UUID `a4d7d2f0-ad8a-460c-86f3-88ba709d41a7`):**
   - **Description:** `"no items"`
   - **Property:** `maximumValue`
   - **Input:**
     ```json
     {
       "maximumWeight": 100,
       "items": {}
     }
     ```
   - **Expected Output:** `0`
   - **Note:** In early problem specifications, `items` was incorrectly specified as an empty object/dictionary `{}` instead of an array.

2. **Reimplemented Canonical Case (UUID `3993a824-c20e-493d-b3c9-ee8a7753ee59`):**
   - **Description:** `"no items"`
   - **Reimplements:** `"a4d7d2f0-ad8a-460c-86f3-88ba709d41a7"`
   - **Property:** `maximumValue`
   - **Input:**
     ```json
     {
       "maximumWeight": 100,
       "items": []
     }
     ```
   - **Expected Output:** `0`
   - **Note:** Added in upstream commit `6c1d8e2761c6dee118f0d9adaf8637fda7007f39` ("Knapsack: Fix empty list of items (#2350)") to correct the `items` type to an array `[]`.

---

## 2. Track State & Example Behavior

### Initial State in `tests.toml`
In `exercises/practice/knapsack/.meta/tests.toml`:
```toml
[a4d7d2f0-ad8a-460c-86f3-88ba709d41a7]
description = "no items"
include = false

[3993a824-c20e-493d-b3c9-ee8a7753ee59]
description = "no items"
reimplements = "a4d7d2f0-ad8a-460c-86f3-88ba709d41a7"
```
The original test entry `a4d7d2f0...` had `include = false` with no `comment` key explaining the exclusion.

### Example Script Verification
The example script `exercises/practice/knapsack/.meta/example.sh` was tested against an empty item list using the canonical inputs:
- **Command:** `bash exercises/practice/knapsack/.meta/example.sh 100`
- **Actual Output:** `0`
- **Exit Status:** `0`
- **Canonical Expected:** `0`

**Algorithm Analysis:**
1. `$1` is assigned to `declare -i max_wt=100`, followed by `shift`.
2. `$#` is `0`, setting `declare -i n=0`.
3. The item parsing loop (`for item; do ...`) executes zero times.
4. Base array `m[0, 1..100]` is initialized to 0.
5. The dynamic programming loop `for ((i=1; i <= n; i++))` does not execute because `n=0`.
6. `echo "${m[$n,$max_wt]}"` prints `${m[0,100]}`, which correctly outputs `0` and exits with status 0.

---

## 3. Decision & Resolution (Option A)

**Decision:** Include the test case (Option A) by removing `include = false` from `[a4d7d2f0-ad8a-460c-86f3-88ba709d41a7]`.

### Supporting Evidence:
1. The Bash example fully supports empty item inputs without any code modifications required.
2. The canonical test for `"no items"` is already supported and generated in `knapsack.bats` via the reimplementing UUID `3993a824-c20e-493d-b3c9-ee8a7753ee59`.
3. Following the repository's convention (as seen in `exercises/practice/poker/.meta/tests.toml`), test cases that are reimplemented by another active test do not require `include = false`; the track test generator (`bin/generate_tests`) automatically filters out superseded UUIDs through the `reimplements` mapping.
4. Removing `include = false` resolves the unexplained exclusion while preserving the test suite and ensuring future `configlet sync` runs recognize the case as included.

---

## 4. Files Changed

1. `exercises/practice/knapsack/.meta/tests.toml`:
   - Removed `include = false` from `[a4d7d2f0-ad8a-460c-86f3-88ba709d41a7]`.
2. `work/R05-T051/findings.md`:
   - Added task evidence and investigation documentation.

---

## 5. Verification Commands & Results

1. **Test Generation Check:**
   ```bash
   python3 bin/generate_tests --no-pull knapsack
   git diff --exit-code -I '^# generated on' exercises/practice/knapsack/knapsack.bats
   ```
   - **Result:** Exit code 0 (Generated tests remain unchanged apart from timestamp, and the `"no items"` test case is present).

2. **Exercise Validation:**
   ```bash
   bin/validate_one_exercise exercises/practice/knapsack
   ```
   - **Result:** Exit code 0 (All 8 tests passed, including `ok 1 no items`).
   ```text
   Processing knapsack
   1..8
   ok 1 no items
   ok 2 one item, too heavy
   ok 3 five items (cannot be greedy by weight)
   ok 4 five items (cannot be greedy by value)
   ok 5 example knapsack
   ok 6 8 items
   ok 7 15 items
   ok 8 error: no arguments
   ```

3. **Track Linting Check:**
   ```bash
   bin/configlet lint
   ```
   - **Result:** Configlet flagged `Missing file: docs/SIGN_UP_SNIPPET.txt`, which is a known pre-existing track documentation gap on `main` unrelated to the `knapsack` exercise. The exercise configuration itself passed linting.
