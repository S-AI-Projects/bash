# Task R05-T034: Review and Refactor Satellite Example Solution (Issue #36)

## Overview & Goals
Review `exercises/practice/satellite/.meta/example.sh` against the Google Shell Style Guide (mandated by `POLICIES.md`) and `shellcheck -o all`, identifying all warnings, style violations, and potential runtime pitfalls (such as global variable leakage across recursive calls and command substitution exit status masking). Refactor the implementation in small, clean, test-verified commits while strictly preserving existing behavior and passing all Bats tests and track checks.

## Policy & Architecture Context
- **Google Shell Style Guide (`POLICIES.md`)**: Track policy mandates adhering to the Google Shell Style Guide for all contributions to maintain consistency across exercises, functions, variables, quoting, and documentation.
- **POSIX Policy**: `POLICIES.md` specifies that Bash track exercises prefer standard Bash 4/5 features (arrays, associative arrays, namerefs, arithmetic evaluations) over strict POSIX compliance.
- **Validation Mechanics (`bin/validate_one_exercise`)**:
  `bin/validate_one_exercise` performs the following steps:
  1. Validates `.meta/config.json` mappings for stub (`satellite.sh`), tests (`satellite.bats`), and example (`.meta/example.sh`).
  2. Confirms exactly one active (uncommented) skip pattern in `satellite.bats` (`case ${exercise}` expects 1 commented-out skip directive).
  3. Registers a cleanup trap: `trap 'git checkout "${stub}"' EXIT`.
  4. Overwrites `satellite.sh` by copying `.meta/example.sh` over it.
  5. Runs the test suite via `BATS_RUN_SKIPPED=true bats "${tests}"`.
  6. Restores `satellite.sh` to its git index state when exiting.
  *Critical workflow rule*: All modifications to `exercises/practice/satellite/.meta/example.sh` must be staged and committed to git *before* invoking `bin/validate_one_exercise`, ensuring working trees remain clean and no uncommitted work is lost or modified during trap cleanup.

---

## Initial Audit Findings (Before Refactoring)

### 1. ShellCheck Findings (`shellcheck -o all`)
Running `shellcheck -o all exercises/practice/satellite/.meta/example.sh` produced 13 diagnostic messages (10 style warnings for parameter bracing, 2 info notices for command substitution masking, and 1 style check for string emptiness):

| Original Line | Code Snippet | Check | Severity | Description |
|---|---|---|---|---|
| 19 | `idx=$( indexOf "$root" "${inorder[@]}" )` | SC2250 | Style | Prefer putting braces around variable references (`${root}`). |
| 22 | `local leftInorder=( "${inorder[@]: 0 : $idx}" )` | SC2250 | Style | Prefer putting braces around variable references (`${idx}`). |
| 23 | `local rightInorder=( "${inorder[@]: $idx+1}" )` | SC2250 | Style | Prefer putting braces around variable references (`${idx}`). |
| 25 | `local leftPreorder=( "${preorder[@]: 1 : $idx}" )` | SC2250 | Style | Prefer putting braces around variable references (`${idx}`). |
| 26 | `local rightPreorder=( "${preorder[@]: $idx+1}" )` | SC2250 | Style | Prefer putting braces around variable references (`${idx}`). |
| 32 | `"$root"` | SC2250 | Style | Prefer putting braces around variable references (`${root}`). |
| 33 | `"$( "$func" "${leftPreorder[*]}" "${leftInorder[*]}" )"` | SC2312 | Info | Invoking command substitution inside `printf` masks return value. |
| 33 | `"$func"` | SC2250 | Style | Prefer putting braces around variable references (`${func}`). |
| 34 | `"$( "$func" "${rightPreorder[*]}" "${rightInorder[*]}" )"` | SC2312 | Info | Invoking command substitution inside `printf` masks return value. |
| 34 | `"$func"` | SC2250 | Style | Prefer putting braces around variable references (`${func}`). |
| 47 | `if [[ ${seen["$elem"]} ]]; then` | SC2244 | Style | Prefer explicit `-n` to check non-empty string. |
| 47 | `"$elem"` | SC2250 | Style | Prefer putting braces around variable references (`${elem}`). |
| 50 | `seen["$elem"]=1` | SC2250 | Style | Prefer putting braces around variable references (`${elem}`). |
| 51 | `if (( $(indexOf "$elem" "${_inorder[@]}") == -1 )); then` | SC2312 | Info | Invoking command substitution inside `(( ... ))` masks return value. |
| 51 | `"$elem"` | SC2250 | Style | Prefer putting braces around variable references (`${elem}`). |
| 63 | `if [[ $needle == "${haystack[i]}" ]]; then` | SC2250 | Style | Prefer putting braces around variable references (`${needle}`). |
| 64 | `echo "$i"` | SC2250 | Style | Prefer putting braces around variable references (`${i}`). |

### 2. Google Shell Style Guide Audit

1. **File Header Comments (§ File Header)**
   - *Line 1*: The script lacked a top-level file header explaining the purpose and implementation of the exercise.
2. **Function Docstrings (§ Function Comments)**
   - *Lines 3, 37, 57, 72*: None of the functions (`buildTree`, `validate`, `indexOf`, `die`) contained comments describing their purpose, input arguments, outputs, and return/exit behavior.
3. **Variable Scoping and Global Leakage (§ Variable Scope)**
   - *Line 46*: In `validate()`, `for elem in "${_preorder[@]}"; do` failed to declare `elem` as `local`. In Bash, loop variables without a `local` declaration default to global scope. In recursive calls or caller scripts, this pollutes the global environment.
   - *Line 51*: The result of `indexOf` was evaluated in an inline subshell within `(( ... ))`. Declaring a scoped local integer variable (`local -i elem_idx`) and storing the result on a separate line prevents return-status masking and scope pollution.
   - *Lines 33-34*: In `buildTree()`, the recursive subshell calls were directly passed as arguments to `printf`. Declaring `local left_tree right_tree` and assigning them separately ensures clean variable scoping and error propagation without masking exit codes.
4. **Parameter Expansion & Bracing (§ Variable expansion)**
   - *Throughout*: Style guide prefers `${var}` over `$var` across all parameter expansions, including positional arguments (`${1}`, `${2}`, `${@}`, `${*}`) and local variables (`${root}`, `${idx}`, `${needle}`, `${i}`).
5. **String Quoting (§ Quoting)**
   - *Lines 7, 8, 38, 58, 63*: Quoting was inconsistent on variable assignments (e.g., `local needle=$1`, `local -n _preorder=$1`). All variable assignments and test comparisons should be quoted.
6. **Conditionals & String Tests (§ Tests)**
   - *Line 47*: Associative array existence check used implicit truthiness `[[ ${seen["$elem"]} ]]`. The style guide requires explicit string tests: `[[ -n "${seen["${elem}"]:-}" ]]`.
7. **Function Definition & Formatting (§ Function Names, Indentation)**
   - *Lines 3, 57*: `buildTree` and `indexOf` use camelCase rather than lowercase snake_case (`build_tree`, `index_of`). Per the issue acceptance criteria, `buildTree`, `validate`, `indexOf`, and `die` must maintain exact behavior and function names for interface compatibility.
   - *Line 72*: `die() { echo "$*" >&2; exit 1; }` used single-line compressed formatting. Functions should have a standardized multi-line body with 2-space indentation.
   - *Line 74*: `buildTree "$@"` was invoked directly at file root. Google Shell Style Guide requires a `main` function for scripts defining functions: `main() { buildTree "${@}"; }` followed by `main "${@}"`.

---

## Line-by-Line Before vs. After Summary

| Scope / Component | Before (`example.sh`) | After (`example.sh`) | Rationale / Rule |
|---|---|---|---|
| File Header | None (line 1 shebang only) | Lines 2-4: Detailed file description | Google Shell Style Guide § File Header |
| `die` function | Line 72: single line `die() { echo "$*" >&2; exit 1; }` | Lines 13-16: multi-line body, 2-space indent, `${*}` | Google Style Guide § Function Comments, Formatting |
| `indexOf` docstring | Line 57: None | Lines 18-25: Arguments and Outputs docstring | Google Shell Style Guide § Function Comments |
| `indexOf` typing & quoting | Line 58-60: `local needle=$1`, unbracketed array | Lines 27-29: `local needle="${1}"`, `local -a haystack`, `local -i i` | SC2250, Google Style Guide § Quoting, Declarations |
| `indexOf` loop & output | Line 63-64: `$needle`, `$i` | Lines 31-37: `${needle}`, `${i}` | SC2250, Google Style Guide § Variable expansion |
| `validate` docstring | Line 37: None | Lines 39-44: Arguments docstring | Google Shell Style Guide § Function Comments |
| `validate` namerefs | Line 38: unquoted `$1`, `$2` | Lines 46-47: `local -n _preorder="${1}"`, `_inorder="${2}"` | Google Style Guide § Quoting, Bracing |
| `validate` local scoping | Line 46: `elem` un-scoped global; Line 51: inline subshell | Lines 53-55: `local elem`, `local -i elem_idx`, `local -A seen=()` | Google Style Guide § Variable Scope, prevents leakage |
| `validate` checks | Line 47: `[[ ${seen["$elem"]} ]]`, Line 51: inline `indexOf` | Lines 58: `[[ -n "${seen["${elem}"]:-}" ]]`, Line 62: separate `elem_idx` | SC2244, SC2312, SC2250 |
| `buildTree` docstring | Line 3: None | Lines 70-77: Arguments and Outputs docstring | Google Shell Style Guide § Function Comments |
| `buildTree` input reading | Line 7-8: `"$1"`, `"$2"` | Lines 81-82: `"${1}"`, `"${2}"` | SC2250, Google Style Guide § Variable expansion |
| `buildTree` indexing & slicing | Lines 17-26: `$root`, `$idx` in slices | Lines 89-97: `local -i idx`, explicit `-a` arrays, `${idx}` | SC2250, Google Style Guide § Declarations, Bracing |
| `buildTree` recursive calls | Lines 29, 33-34: `func=${FUNCNAME[0]}`, inline subshell inside `printf` | Lines 99-106: `local left_tree right_tree`, explicit assignments | SC2312, Google Style Guide § Return Values |
| Script entrypoint | Line 74: `buildTree "$@"` at root | Lines 114-122: `main()` function with `main "${@}"` | Google Shell Style Guide § Calling main |

---

## Refactoring Commits

1. `bedc9af` - `R05-T034: Audit and document style guide and ShellCheck findings for satellite`
2. `ddcfdd6` - `R05-T034: Fix variable scoping and resolve command substitution masking in satellite`
3. `4ea166a` - `R05-T034: Enforce parameter expansion bracing, quoting, and explicit tests in satellite`
4. `917cb4f` - `R05-T034: Add Google Shell Style documentation, indentation, and main entrypoint in satellite`
5. `R05-T034: Record validation logs and final verification evidence`

---

## Verification Evidence & Results

- **ShellCheck Zero-Issue Verification**:
  - Initial run: 13 findings recorded in `work/R05-T034/initial_shellcheck.txt`.
  - Final run: `shellcheck -o all exercises/practice/satellite/.meta/example.sh` reports **zero** issues and exits with code 0 (recorded in `work/R05-T034/final_shellcheck.txt`).
  - No `# shellcheck disable` annotations required.
- **Test Suite Verification**:
  - `bin/validate_one_exercise exercises/practice/satellite` passes all **9** satellite tests (recorded in `work/R05-T034/validator_log.txt`):
    - ok 1 Empty tree
    - ok 2 Tree with one item
    - ok 3 Tree with many items
    - ok 4 Reject traversals of different length
    - ok 5 Reject inconsistent traversals of same length
    - ok 6 Reject traversals with repeated items
    - ok 7 A degenerate binary tree
    - ok 8 Another degenerate binary tree
    - ok 9 Tree with many more items
- **Configlet Sync Verification**:
  - `bin/configlet sync -e satellite` passes: "The `satellite` exercise has up-to-date docs, filepaths, metadata, and tests!" (recorded in `work/R05-T034/configlet_sync.txt`).
- **Working Tree Cleanliness**:
  - `git status` verifies `exercises/practice/satellite/satellite.sh` is unmodified.
