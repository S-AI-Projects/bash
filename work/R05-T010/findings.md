# R05-T010: add the matrix practice exercise

## Goal
`matrix` is in problem-specifications (8 canonical cases) but not in the Bash
track. Add it as a complete practice exercise.

## What I read
`problem-specifications/exercises/matrix`: `description.md` (instructions),
`canonical-data.json` (8 cases, properties `row` and `column`, input `string`
and 1-based `index`, expected a list of numbers) and `metadata.toml` (blurb,
source, source_url). I used `spiral-matrix` as a model for the exercise layout.

## Mapping the cases to the command line
`bash matrix.sh <matrix> {row|column} <index>`
- `string` -> first argument, passed with `$'...'` so `\n` becomes a newline
  (the same `${{ ... | repr }}` idiom `bob` and `kindergarten-garden` use).
- `property` -> second argument (`row` or `column`).
- `index` -> third argument, counting from 1 like the canonical data.
- `expected` -> the numbers on one line separated by spaces.
All 8 cases are included; none needed `include = false`.

## Files added
- `exercises/practice/matrix/matrix.sh` (stub), `bats-extra.bash`
- `.docs/instructions.md` (from problem-specifications), `.docs/instructions.append.md`
  (documents the CLI)
- `.meta/config.json`, `.meta/tests.toml` (the 8 canonical UUIDs),
  `.meta/template.j2`, `.meta/example.sh`
- `matrix.bats`, generated with `bin/generate_tests matrix` (8 tests, only the
  first unskipped)
- `config.json`: new entry (new UUID from `bin/configlet uuid`, difficulty 3,
  topics arrays, parsing, strings), placed in difficulty order.

## Example solution
`row` splits the chosen line into numbers and prints them; `column` takes the
chosen number from every line. It also checks the argument count, the property
and the index range (not covered by the tests, since the canonical data has no
error cases). `shellcheck -o all` is clean.

## Results
Validator (`validate.txt`):
    Processing matrix
    1..8
    ok 1 test_extract_row_from_one_number_matrix
    ok 2 test_can_extract_row
    ok 3 test_extract_row_where_numbers_have_different_widths
    ok 4 test_can_extract_row_from_non_square_matrix_with_no_corresponding_column
    ok 5 test_extract_column_from_one_number_matrix
    ok 6 test_can_extract_column
    ok 7 test_can_extract_column_from_non_square_matrix_with_no_corresponding_row
    ok 8 test_extract_column_where_numbers_have_different_widths
    Updated 1 path from the index

`bin/configlet lint` (`lint.txt`):
    The lint command is under development.
    To check your track using the latest linting rules,
    please regularly update configlet and re-run this command.
    
    The `exercises.foregone` array contains the slug `matrix`, but there is an implemented exercise with that slug:
    /Users/ahaanshrivastava/bash/config.json
    
    Configlet detected at least one problem.
    For more information on resolving the problems, please see the documentation:
    https://exercism.org/docs/building/configlet/lint

## Environment notes
- My copy of `bin/generate_tests` has no `--no-pull` flag, so I ran
  `python3 bin/generate_tests matrix`.
- On macOS the validator was run with GNU grep, `bats-core`, bash 5 and
  `jq` from Homebrew. The new files were committed before running the
  validator, because it runs `git checkout` on the stub.
