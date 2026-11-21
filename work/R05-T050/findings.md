# R05-T050 — Findings: Add the missing 'etl' exercise to the Bash track

Student: Hemant Gandhe (E26B07F0874)
Task: R05-T050, Issue 51 in S-AI-Projects/bash
Branch: R05-T050, from main 9567ba5

## What 'etl' is

From problem-specifications: transform a score → letters mapping (legacy
Lexiconia data) into a letter → score mapping, lower-casing the letters.
4 canonical cases, all included (bash can support all of them, so no
`include = false` was needed):

| UUID | Description | Input | Expected |
|---|---|---|---|
| 78a7a9f9-4490-4a47-8ee9-5a38bb47d28f | single letter | `{"1": ["A"]}` | `{"a": 1}` |
| 60dbd000-451d-44c7-bdbb-97c73ac1f497 | single score with multiple letters | `{"1": ["A","E","I","O","U"]}` | `{"a":1,"e":1,"i":1,"o":1,"u":1}` |
| f5c5de0c-301f-4fdd-a0e5-df97d4214f54 | multiple scores with multiple letters | `{"1": ["A","E"], "2": ["D","G"]}` | `{"a":1,"d":2,"e":1,"g":2}` |
| 5db8ea89-ecb4-4dcd-902f-2b418cc87b9d | multiple scores with differing numbers of letters | full Scrabble set (1,2,3,4,5,8,10) | all 26 letters a–z |

## Design (input/output format)

There is no `etl` exercise in upstream exercism/bash yet (checked: the path
does not exist there), so the format was designed fresh, following this
track's own conventions:

- Tests call the script the way POLICIES.md requires — `run bash etl.sh
  "..."` with no subcommand and no enforced function name — the same
  pattern as `word-count`, which also outputs a mapping.
- Input: one command-line argument per score group, in the form
  `<score>:<LETTER>,<LETTER>,...`, e.g. `bash etl.sh "1:A,E" "2:D,G"`.
- Output: one line per letter, `<letter>: <score>`, lower-cased, e.g. `a: 1`.
  The example prints the lines sorted alphabetically; tests use
  `assert_line` (order-insensitive, like `word-count`) plus a line-count
  check, so a student's solution may print the lines in any order.
- The format is documented in `.docs/instructions.append.md` (the
  convention already used by darts, grep, gigasecond and others in this
  track). The first case `{"1": ["A"]}` → `{"a": 1}` is the first generated
  test ("single letter").
- Difficulty 4 (the canonical ETL difficulty; matches the track's other
  difficulty-4 exercises), topics `control_flow_loops`,
  `string_transformation`, `strings` (all already used in this track).
- `.meta/example.sh` uses an associative array (`declare -A`), `${letter,,}`
  lower-casing and `LC_ALL=C sort`; it follows the Google Shell Style
  Guide and `shellcheck` is clean on it.

## How it was built

- `bin/configlet create --practice-exercise etl --offline -d 4 -a HemantAsur`
  (configlet 4.0.1) scaffolded the exercise and added the `config.json`
  entry (uuid `263ab7e8-41d9-4a27-a7c7-299c59fbe02e`). Two setup notes:
  configlet first refused the cached problem-specifications because it was
  a `--depth 1` clone ("unexpected initial commit"); a full clone fixed
  that. The `bin/fetch-configlet` download had already failed earlier with
  a GitHub API rate limit, so the 4.0.1 binary in `/tmp/configlet401/` was
  used.
- Then filled in the stub (`etl.sh`, generic starter comments like the
  other exercises), `.meta/example.sh`, `.meta/template.j2`, and
  `.docs/instructions.append.md`; added the topics to the `config.json`
  entry; generated `etl.bats` with `bin/generate_tests --no-pull etl`.

## Three things that broke, and the fixes

1. **Missing `bats-extra.bash`.** First validation failed with
   `bats_load_safe: Could not find '.../etl/bats-extra'`. Every other
   practice exercise ships a copy of the bats-support/bats-assert bundle
   as `bats-extra.bash`; configlet does not create it. Copied the
   identical 18,153-byte file from `run-length-encoding`.
2. **`etl` was still in `exercises.foregone`.** Configlet lint reported
   "`exercises.foregone` contains the slug `etl`, but there is an
   implemented exercise with that slug". Removed `etl` from the foregone
   list in `config.json` (3 deletions in the diff are the foregone entry
   plus the added topics/entry lines).
3. **One extra `}` in the template.** First validation passed the
   `assert_line` checks but every `assert_equal` failed with
   `actual : 1}` (etc.): the generated line was
   `assert_equal "${#lines[@]}}" 1`. My template had one `}` too many
   after `[@]` compared with `word-count`'s template (brace count 6 vs
   5). Removed one `}`; regenerated; all 4 tests pass.

## Checks (full output: `check-demo.txt`)

- `bin/validate_one_exercise exercises/practice/etl` → 4/4 tests pass.
- `bin/configlet lint` (configlet 4.0.1) → "Basic linting finished
  successfully".
- `bin/generate_tests --no-pull etl` re-run → exit 0, no files changed
  (generated `.bats` is stable).
- `shellcheck .meta/example.sh` → clean, exit 0.
- Work was committed before validation, as the issue instructs
  (the validator copies `.meta/example.sh` over the stub, then runs
  `git checkout` on the stub).

## PR

- Base: S-AI-Projects/bash, head: HemantAsur/bash:R05-T050 (branch
  `R05-T050`)
- One commit with the code change plus this `work/R05-T050/` folder.
- For a later upstream PR, create a second branch containing only the
  code change (no `work/` folder), and discuss the change first on
  forum.exercism.org (Bash category) and link the thread — maintainers
  close undiscussed PRs.
