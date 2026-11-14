# R05-T006: leap approaches article

## Goal
`leap` already had three approaches (boolean chain, ternary operator, external
tools). Add a fourth approach article, register it in `config.json`, and mention
it in `introduction.md`.

## Study
- `.approaches/config.json`: each approach has `uuid`, `slug`, `title`, `blurb`
  and `authors`.
- `.approaches/introduction.md`: a section per approach with its snippet and a
  link to the approach page, then a "Which approach to use?" list.
- Each approach folder has `content.md` (the article) and `snippet.txt` (a short
  snippet for the exercise page).
- The first two existing approaches already use `(( ))`, and `external-tools`
  already covers `date`, so the new approach is a `case` statement, which the
  track did not have.

## New approach: case statement
```bash
year=$1
case "$(( year % 4 )),$(( year % 100 )),$(( year % 400 ))" in
    0,0,0) echo true ;;
    0,0,*) echo false ;;
    0,*)   echo true ;;
    *)     echo false ;;
esac
```
The three remainders (for 4, 100 and 400) are joined into one word such as
`0,20,20`, and `case` runs the first pattern that matches. The order of the
patterns is part of the rule: `0,0,*` must come before `0,*`, or 1900 would be
reported as a leap year.

## Files changed
- `exercises/practice/leap/.approaches/case-statement/content.md` (new): the
  article, with a table of the patterns, a worked table for 2020, 2019, 2000 and
  1900, a note on pattern order, a comparison with the Boolean chain, and a note
  on `case` globbing.
- `exercises/practice/leap/.approaches/case-statement/snippet.txt` (new): the
  7-line snippet above.
- `exercises/practice/leap/.approaches/config.json`: fourth approach with a UUID
  from `bin/configlet uuid`, slug `case-statement`, title, blurb and authors.
- `exercises/practice/leap/.approaches/introduction.md`: new "Approach: Case
  statement" section with the snippet and a link, a line in the overview, a
  bullet in "Which approach to use?", and the link reference.

## Checking the snippets
The leap tests include four argument-error tests that the snippets do not handle,
since a snippet is only the leap calculation. `check_snippets.sh` therefore puts
the same argument validation in front of each `snippet.txt` to make a complete
solution, then runs all 13 leap tests against it. It exits non-zero if any
approach fails. I also confirmed that a deliberately wrong snippet fails.

Results (`check_snippets_output.txt`):
- boolean-chain: PASS (13 of 13 tests)
- case-statement: PASS (13 of 13 tests)
- external-tools: PASS (13 of 13 tests)
- ternary-operator: PASS (13 of 13 tests)

`bin/configlet lint`: basic linting finished successfully, including "Every
approach and article is valid" (`configlet_lint.txt`).

## Environment notes
- The `external-tools` snippet uses GNU `date -d`, which the BSD date on macOS
  does not support, so `check_snippets.sh` puts `coreutils` (Homebrew) first on
  the PATH when the system date is not GNU.
- On macOS the tests were run with bash 5, GNU grep and `bats-core` from Homebrew.
