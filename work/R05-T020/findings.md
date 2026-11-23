# Task R05-T020 Findings: Add Missing 'saddle-points' Exercise

## 1. Overview and Problem Analysis

The `saddle-points` exercise existed in `problem-specifications` with 9 canonical test cases, but was listed under `exercises.foregone` in the Bash track.
A saddle point is defined as an element in a matrix that is greater than or equal to all elements in its row and less than or equal to all elements in its column.

## 2. CLI Interface & Design Decisions

In accordance with Step 1 and the task criteria:
- **Matrix Input Representation**: Passed as command-line arguments, where each positional argument corresponds to a row containing space-separated integers (e.g. `saddle_points.sh "9 8 7" "5 3 2" "6 6 7"`).
- **Empty Matrix Handling**: An empty matrix is represented by no arguments (or empty arguments), producing no output with exit code `0`.
- **Output Format**: Each identified saddle point is printed on a separate line as:
  ```text
  row <r>, column <c>
  ```
  using 1-based indexing, sorted in ascending order of row, then column.
- **First Case Verification**:
  Matrix `[[9,8,7],[5,3,2],[6,6,7]]` evaluates to `row 2, column 1`.
- **Documentation**: Documented fully in `exercises/practice/saddle-points/.docs/instructions.append.md`.

## 3. Track Configuration & Exercise Setup

1. **Configlet Creation**:
   Generated initial scaffolding via `bin/configlet create --practice-exercise saddle-points`.
2. **Track `config.json`**:
   - Removed `saddle-points` from `exercises.foregone`.
   - Configured practice exercise entry with difficulty `5` and topics `["arrays", "control_flow_loops"]`.
   - Validated formatting via `bin/configlet fmt --yes`.
3. **Template & Test Generation**:
   - Authored `exercises/practice/saddle-points/.meta/template.j2`.
   - Generated `exercises/practice/saddle-points/saddle_points.bats` using `bin/generate_tests --no-pull saddle-points`.
   - All 9 canonical test cases from `problem-specifications` are included and tested.
4. **Implementation**:
   - `saddle_points.sh`: Standard solution stub.
   - `.meta/example.sh`: Parses rows into flat array, precomputes row maximums and column minimums in $O(R \times C)$, and identifies coordinates satisfying saddle point criteria.

## 4. Verification and Results

### 4.1 Test Execution (`bin/validate_one_exercise`)
All 9 test cases pass:
```text
Processing saddle-points
1..9
ok 1 Can identify single saddle point
ok 2 Can identify that empty matrix has no saddle points
ok 3 Can identify lack of saddle points when there are none
ok 4 Can identify multiple saddle points in a column
ok 5 Can identify multiple saddle points in a row
ok 6 Can identify saddle point in bottom right corner
ok 7 Can identify saddle points in a non square matrix
ok 8 Can identify that saddle points in a single column matrix are those with the minimum value
ok 9 Can identify that saddle points in a single row matrix are those with the maximum value
```

### 4.2 ShellCheck
Zero warnings with `shellcheck -o all`:
```bash
shellcheck -o all exercises/practice/saddle-points/.meta/example.sh exercises/practice/saddle-points/saddle_points.sh
```

### 4.3 Configlet Lint
Configlet lint reports no errors for `saddle-points`.

### 4.4 Forum Thread Link
Exercism discussion thread: https://forum.exercism.org/t/adding-saddle-points-to-bash-track/
