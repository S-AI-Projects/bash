# R05-T047: instructions.append.md for 'rna-transcription'

## What was added
`exercises/practice/rna-transcription/.docs/instructions.append.md`: four bash-specific hints, shown to
learners after the shared instructions. The file starts with `# Dummy header`, which is the convention in
the other append files in this track (darts, list-ops, grep, hello-world, error-handling).

| # | Hint | Verified example (run verbatim) |
|---|---|---|
| 1 | `${var//pattern/replacement}` replaces every match, `${var/p/r}` only the first; warns that chained replacements can undo each other | `banana` gives `bonono` / `bonana`; `xy` ends up as `xx` |
| 2 | `tr` translates in one pass (first set to second set), so nothing is undone; compares it with parameter expansion | `tr 'el' 'ip' <<< "hello"` gives `hippo` |
| 3 | rejecting invalid characters: `[!abc]` in a glob pattern inside `[[ ... ]]`, covering "Handles partially invalid string" | `abcabc` is ok, `abcxabc` is bad |
| 4 | print nothing but the error (decide validity before printing) and exit non-zero | `exit 3` is visible as `$?` |

All examples use other letters (`a/o`, `x/y`, `el/ip`, `abc`), so the DNA to RNA mapping is not given away.
Links are to the Bash manual (parameter expansion, pattern matching, `[[`); these are links already used
elsewhere in this repo. The `tr` hint points to `man tr` rather than a web page.

## Checks (`check_hints.sh`, output in `check_hints.out`)
1. Every ```bash block in the file is run and its output must equal its `# =>` comments (5 examples, all ok).
2. Spoiler check: no DNA to RNA mapping in the file; 4 hints (the task asks for 3-5).
3. I solved the exercise first, two ways (`solutions/solution_tr.sh`, `solutions/solution_substitution.sh`):
   both pass all 9 tests. The two traps the hints warn about really fail 3 tests each
   (`trap_chained_substitution.sh`: tests 3, 4, 6; `trap_print_before_validating.sh`: the invalid-character tests).
4. `markdownlint-cli2` (default rules): 0 issues.
Negative controls: a wrong expected output, an added spoiler and an over-long line each made the script fail
(and passed again once restored).

## Notes for the reviewer
- The solutions are in `work/` on purpose and are not part of the code change. They would be spoilers if
  they were in the exercise folder, and `work/` is left out of the upstream PR.
- The existing append files do not pass default markdownlint (for example 80-column line length). They were
  not touched, since that is outside this task; the new file passes.
- Not run in the environment where this was written: `bin/configlet lint` (configlet could not be
  downloaded), the `npx --yes markdownlint-cli2` form (a locally installed markdownlint-cli2 0.23.2 was used),
  and real `bats` (a small stand-in was used for the solution runs). The gnu.org links could not be opened
  from that environment either; they are copied from links already used in this repo.
