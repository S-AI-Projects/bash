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

## Initial Audit Findings

### 1. ShellCheck Findings (`shellcheck -o all`)
Running `shellcheck -o all exercises/practice/satellite/.meta/example.sh` produced 13 diagnostic messages (10 style warnings for parameter bracing, 2 info notices for command substitution masking, and 1 style check for string emptiness):

| Line | Code Snippet | Check | Severity | Description |
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
   - *Line 1*: The script lacked a descriptive top-level file header explaining what the script implements and how binary tree reconstruction operates.
2. **Function Docstrings (§ Function Comments)**
   - *Lines 3, 37, 57, 72*: None of the functions (`buildTree`, `validate`, `indexOf`, `die`) contained comments describing their purpose, input arguments, outputs, and return/exit behavior.
3. **Variable Scoping and Global Leakage (§ Variable Scope)**
   - *Line 46*: In `validate()`, `for elem in "${_preorder[@]}"; do` did not declare `elem` as `local`. In Bash, loop variables without a `local` declaration default to global scope. In recursive calls or caller scripts, this pollutes the global environment.
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

## Planned Refactoring Commits

1. **Commit 1: Variable Scoping and Command Substitution Masking**
   - Declare `local elem` and `local -i elem_idx` in `validate()`, eliminating global variable leakage.
   - Separate recursive calls in `buildTree()` into explicit `local left_tree right_tree` assignments, resolving SC2312 and preventing status masking.
   - Explicitly type arrays (`local -a`) and integers (`local -i`) where applicable.
2. **Commit 2: Quoting, Parameter Expansion Bracing, and Explicit Conditionals**
   - Enforce `${var}` parameter expansion bracing across all functions (resolving all SC2250 warnings).
   - Use explicit `-n` non-empty string check for associative array presence (resolving SC2244).
   - Quote all parameter expansions and assignments consistently.
3. **Commit 3: Google Style Documentation, Indentation, and Main Entrypoint**
   - Add top-level file header comment and detailed Google-style function docstrings.
   - Reformat functions to standard multi-line layout with 2-space indentation.
   - Add `main()` entrypoint function calling `buildTree "${@}"`.

---

## Verification Checklist & Results

- [x] Initial `shellcheck -o all` captured in `work/R05-T034/initial_shellcheck.txt`.
- [x] Refactored in small, clean commits.
- [x] Committed each change prior to running `bin/validate_one_exercise`.
- [x] Zero ShellCheck issues reported without any `# shellcheck disable` comments.
- [x] All 9 Bats tests passing in `bin/validate_one_exercise exercises/practice/satellite`.
- [x] `bin/configlet sync -e satellite` confirms exercise metadata is up to date.
- [x] `git status` clean and stub `satellite.sh` unmodified.
