# R05-T054 — Bring `diamond` `example.sh` up to the style guide

**Student:** Harshit Dhablia (E26B07F1068)  
**Task:** R05-T054 · 4 of 10  
**Issue:** https://github.com/S-AI-Projects/bash/issues/54  
**Target File:** `exercises/practice/diamond/.meta/example.sh`  

---

## 1. Initial ShellCheck & Style Guide Findings

Running `shellcheck -o all exercises/practice/diamond/.meta/example.sh` and reviewing against the Google Shell Style Guide (mandated by `POLICIES.md`) identified the following issues in the original 90-line example:

| Line(s) | Code / Category | Description |
|---------|-----------------|-------------|
| 3, 7, 11, 21, 29, 45, 61 | Style / Formatting | Space between function name and parentheses `func () {` instead of standard `func() {`. |
| 4 | Style / Formatting | Multiple statements joined with `&&` (`printf ... && exit 1`) instead of separate statements. |
| 8 | SC2053 (Warning) | Quote right-hand side of `!=` in `[[ ]]`: `$1 != ${1//[![:upper:]]/}` -> `"${1}" != "${1//[![:upper:]]/}"` to prevent glob matching. |
| 8 | SC2250 (Style) | Unbraced parameter expansions in arithmetic/test context (`$1`, `${#1}`). |
| 12, 14 | Local Variables | `padding` and `x` in `pad()` were not declared `local`, leaking into global scope. |
| 15 | SC2250 (Style) | `[[ $x -le $padding ]]` used unbraced variables; replaced with idiomatic bash arithmetic loop `(( x <= padding ))`. |
| 16, 24, 26, 39, 55 | Quoting / printf | `printf ' '`, `printf 'A'`, `printf "\n"` did not use quoted constant format strings. |
| 22 | Local Variables | `padding` in `line_a()` was not declared `local`. |
| 23, 25 | SC2086 / SC2248 / SC2250 | `pad $padding` unquoted and unbraced -> `pad "${padding}"`. |
| 30, 31 | Local Variables | `level`, `int_padding`, `ext_padding` in `up_to_max()` were not declared `local`. |
| 31, 47 | Style / Formatting | Multiple variable assignments on single line: `int_padding=1 ext_padding=$(( line_width / 2 - 1 ))`. |
| 32, 48 | SC2250 (Style) | `while [[ $level -le $max_level ]]` -> replaced with arithmetic `while (( level <= max_level ))`. |
| 33, 49 | SC2250 (Style) | `letter="${from_idx_map[$level]}"` -> `letter="${from_idx_map[${level}]}"`. |
| 34, 36, 38, 50, 52, 54 | SC2248 / SC2250 | `pad $ext_padding` / `pad $int_padding` -> `pad "${ext_padding}"` / `pad "${int_padding}"`. |
| 35, 37, 51, 53 | SC2250 (Style) | `printf "%s" "$letter"` -> `printf '%s' "${letter}"`. |
| 40, 56 | Style / Formatting | Multiple statements on one line: `((level++)); ((ext_padding--))`. |
| 41, 57 | Style / Arithmetic | `int_padding=$(( int_padding + 2 ))` -> `(( int_padding += 2 ))`. |
| 46, 47 | Local Variables | `level`, `ext_padding`, `int_padding` in `down_to_last()` were not declared `local`. |
| 64 | Naming Convention | `readonly LETTER="$1"` in `main()` used uppercase for a function-local variable; changed to lowercase `local -r letter="${1}"`. |
| 72, 73 | Local Variables | Loop counters `i` and `ch` in `main()` were not declared `local`. |
| 74, 75, 80 | SC2250 (Style) | Unbraced array indices in `to_idx_map` and `from_idx_map`. |

---

## 2. Refactoring Summary

All seven functions (`error`, `check_args`, `pad`, `line_a`, `up_to_max`, `down_to_last`, `main`) were refactored to:
1. Declare all internal variables with `local` (or `local -r` / `local -i`).
2. Use quoted constant format strings for all `printf` calls (`printf '%s' ' '`, `printf '%s' "${letter}"`, `printf '\n'`).
3. Quote and brace all variable references per SC2248 and SC2250.
4. Separate statements and assignments onto individual lines.
5. Add concise Google-style function header comments.
6. Preserve exact behavioral symmetry, output, and exit statuses.

---

## 3. Validation Results

| Check | Command | Result |
|-------|---------|--------|
| ShellCheck (all checks) | `shellcheck -o all exercises/practice/diamond/.meta/example.sh` | **Clean (0 warnings, 0 errors, exit 0)** |
| Diff Check | `git diff --check` | **Clean (exit 0)** |
| Exercise Validator | `bin/validate_one_exercise exercises/practice/diamond` | **5/5 tests passed (exit 0)** |
| Edge Cases | `A`, `B`, `C`, empty, non-letter, extra args | **100% identical outputs and exit codes** |
