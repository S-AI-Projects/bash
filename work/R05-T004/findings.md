# R05-T004: rectangles example solution review

## Goal
Review `exercises/practice/rectangles/.meta/example.sh` (105 lines) against
ShellCheck and the Google Shell Style Guide, and improve it without changing
behaviour.

## Method
- `shellcheck -o all .meta/example.sh` before the change: 20 locations reported
  (`shellcheck_before.txt`).
- Read POLICIES.md and the style guide sections on functions, variables and quoting.
- Fixed the issues in three small commits and ran `bin/validate_one_exercise
  exercises/practice/rectangles` after each one (14 of 14 tests ok each time).
- `shellcheck -o all` after the change prints nothing (`shellcheck_after.txt`
  is empty). No `# shellcheck disable=` was needed.

## Issues and fixes
| Lines | Issue | Fix | Commit |
|---|---|---|---|
| 28, 29, 30, 31, 33, 64, 66, 67, 76, 77, 84, 85 | SC2086 (unquoted expansion) and SC2250 (no braces) | `"${var}"` | 1 |
| 74 | SC2086: `parse_vertex $1` | `"${vertex}"`, the variable already assigned on line 73 | 1 |
| 33, 40, 87, 88, 89, 90 | SC2248 (prefer double quotes) and SC2250 | `"${count}"`, `"${r1}"`, `"${c1}"` and so on | 1 |
| 32, 48 | SC2250 inside strings | `"${r1},${c2}"`, `"${r},${c}"` | 1 |
| 18 | style: loop variable `i` in `main` is global | `local -i count=0 i` | 2 |
| 65, 75 | style: loop variable `v` in `verts_to_right` and `verts_below` is global | `local v` in both functions | 2 |
| 5 | style: informal comment | describes the shared state (rows, vertices, width) | 3 |
| 23 | style: trailing whitespace | removed | 3 |
| all functions | style: functions need a comment | one comment above each function | 3 |

ShellCheck does not report the global `i` and `v`. They are real leaks: before
the change `v` was still set in the caller after `verts_to_right` ran, and after
the change it is not.

## Behaviour
- No function was renamed: `main`, `find_vertices`, `parse_vertex`,
  `verts_to_right`, `verts_below`, `is_rectangle`, `horizontal_line` and
  `vertical_line` keep their names and purpose.
- Only quoting, braces, `local` declarations, comments and whitespace changed.
  The 14 tests pass after every commit.
- The grid is still read with `readarray -t rows` and the corner loops are
  unchanged.

## Results
- `shellcheck -o all exercises/practice/rectangles/.meta/example.sh`: no output.
- `bin/validate_one_exercise exercises/practice/rectangles`: 14 of 14 tests ok.

## Environment notes
- On macOS the validator was run with GNU grep (the stock grep lacks `-P`),
  `bats-core`, bash 5 and `shellcheck` from Homebrew.
