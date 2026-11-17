# R05-T044 — Triangle Shell Style Review

## Original ShellCheck findings

Command:
shellcheck -f gcc -o all "$HOME/triangle-example-original.sh"

| Original line(s) | ShellCheck code | Finding |
|---|---|---|
| 21 | SC2086 | Quote variable expansion |
| 21 | SC2312 | Avoid masking command substitution return status |
| 27 | SC2292 | Prefer [[ ]] over [ ] |
| 27, 46, 76 | SC2086 | Quote variable expansions |
| 27, 46, 76 | SC2250 | Use braces around variable references |
| 39, 41, 46, 53, 59, 65 | SC2310 | Function calls in conditional expressions affect set -e behavior |

## Changes made

- Quoted variable expansions.
- Used [[ ]] for Bash conditional tests.
- Added braces around variable references.
- Used local variables inside functions.
- Checked the return status of the bc command substitution.
- Improved function and script comments.
- Organized argument validation and dispatch in main.
- Documented the SC2310 suppression in the script header.

## SC2310 suppression rationale

The predicate functions intentionally return nonzero when a comparison is false.
Their callers explicitly handle those return statuses through if, &&, and ||.
The assert function also explicitly checks command substitution and comparison
failures. The suppression documents this intentional conditional behavior.

## Validation

- ShellCheck: shellcheck -o all exercises/practice/triangle/.meta/example.sh
- ShellCheck result: exit code 0, no diagnostics.
- Exercise validator: bin/validate_one_exercise exercises/practice/triangle
- Triangle tests: 21/21 passed.
