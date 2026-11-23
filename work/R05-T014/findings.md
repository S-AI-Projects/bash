# Task R05-T014 Findings: Bring 'poker' example.sh up to the style guide

## Student Information
- Name: ARYA PRAJAPATI
- Task ID: R05-T014
- Issue: #18

## Issues Identified and Fixes Applied

| Issue Category | ShellCheck Code / Rule | Original Problem | Resolution |
|---|---|---|---|
| Shebang | Google Style Guide | `#!/usr/bin/bash` | Changed to `#!/usr/bin/env bash` for portability across environments. |
| Array quoting | SC2068 | Unquoted `${values[@]}` and `$@` expansions | Quoted all array and argument expansions: `"${values[@]}"`, `"$@"`. |
| Variable scoping | SC2178 | Variable `value` in `ranking()` shadowed `local -A value` from caller | Renamed `value` in `main()` to `hand_scores` and `formatted_rank` in `ranking()` to prevent dynamic scope shadowing. |
| Unsafe read | SC2162 | `while read g v; do` without `-r` flag | Changed to `while read -r g v; do`. |
| Unquoted array append | SC2206 | `groups+=($g)` and `values+=($v)` unquoted | Changed to `groups+=("${g}")` and `values+=("${v}")`. |
| Word splitting | SC2086 / SC2250 | Word splitting via unquoted `$cards` in `printf` | Safely parsed cards into arrays via `read -ra card_arr <<< "${cards}"` before passing `"${card_arr[@]}"`. |
| Function decomposition | Style Guide | Massive `evaluate()` function handled parsing, classification, and math | Decomposed into `classify_hand_rank()` and `evaluate()`, ensuring all functions fit on a single screen. |
| Subshell pipeline masking | SC2312 | Pipeline exit codes inside command substitution | Added specific, documented `# shellcheck disable=SC2312` directives for deliberate pipelines. |

## Verification
- `shellcheck -o all exercises/practice/poker/.meta/example.sh` passes cleanly with exit code 0.
- All 37 poker tests pass cleanly via `bin/validate_one_exercise exercises/practice/poker`.
