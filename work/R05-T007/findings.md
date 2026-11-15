# R05-T007: Bash-specific hints for grains

## Goal
`grains` had no `.docs/instructions.append.md`. Add Bash-specific hints that
explain Bash's integer limits (square 64 is 2^63, which overflows a signed
64-bit integer) without giving away how to print the right value.

## Method
1. Solved the exercise myself first (`solution.sh`, kept in `work/`, not part of
   the PR). All 11 grains tests pass (`solution_tests.txt`).
2. Read `darts`, `list-ops` and `gigasecond` `instructions.append.md` for tone and
   format: a top-level heading, `##` sections, short paragraphs, `bash` code
   blocks with `# =>` result comments, and reference-style links.
3. Wrote five hints. Each has a small example I ran in bash 5 and a link to the
   Bash manual's arithmetic section. The `# =>` comments were checked against
   the real output (`hint_examples.txt`).
4. Ran `bin/configlet lint` and `markdownlint-cli2` (`lint.txt`,
   `markdownlint.txt`).

## Hints and verified examples
| Hint | Example | Verified output |
|---|---|---|
| Powers of two | `echo $(( 2 ** 3 ))` | `8` |
| Bash integers have a size limit | `echo $(( 2 ** 62 ))` | `4611686018427387904` |
| Overflow does not raise an error | `echo $(( 2 ** 63 ))` | `-9223372036854775808` |
| | `echo $(( 9223372036854775807 + 1 ))` | `-9223372036854775808` |
| | `echo $(( 2 ** 64 ))` | `0` |
| Shifting instead of multiplying | `echo $(( 1 << 63 ))` | `-9223372036854775808` |
| Words in arithmetic expressions | `unset total; [[ total -lt 1 ]] && echo yes` | `yes` |

## Not giving the trick away
The hints say that Bash integers are signed 64-bit, that 2^63 overflows, that
overflow wraps silently, and that the learner will need a way around the limit.
They do not mention `printf`, `%u` or "unsigned", and they do not show the
solution.

## Results
- `bin/configlet lint`: passes (`lint.txt`).
- `markdownlint-cli2`: 0 issues (`markdownlint.txt`).
- My solution: 11 of 11 tests ok (`solution_tests.txt`).

## Environment notes
- On macOS the examples were run with bash 5 from Homebrew. The default shell
  (zsh) handles large numbers differently, so the examples are Bash-specific.
- Default markdownlint limits lines to 80 characters, so the text is hard-wrapped.
