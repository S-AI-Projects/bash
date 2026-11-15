# R05-T008: topics for save-the-cow in config.json

## Goal
The `save-the-cow` entry in `config.json` (difficulty 4) had no topics. Derive
topics from the Bash features its example solution uses.

## Method
1. Read the entry: it had `practices`, `prerequisites` and `difficulty` but no
   `topics` key at all.
2. Listed the difficulty-4 exercises with jq and compared `save-the-cow` with
   three of them (`comparison_before.md`, `comparison_after.md`).
3. Read `.meta/example.sh` (41 lines) and listed the Bash features it uses.
4. Chose topics from the vocabulary the track already uses, so no new topic
   names are introduced.
5. Edited only the `save-the-cow` entry, then ran `bin/configlet lint` and the
   jq check.

## jq commands
```bash
# difficulty-4 exercises
jq -r '.exercises.practice[] | select(.difficulty == 4) | .slug' config.json

# topics of one exercise
jq -r '.exercises.practice[] | select(.slug == "diamond") | .topics | join(", ")' config.json
```
`work/R05-T008/compare.sh` builds the table below from these.

## Comparison (before the change)
| exercise | difficulty | tests | example lines | topics |
|---|---|---|---|---|
| save-the-cow | 4 | 10 | 41 | none |
| pig-latin | 4 | 24 | 22 | conditionals, regular_expressions |
| diamond | 4 | 5 | 90 | loops, string_transformation, strings |
| kindergarten-garden | 4 | 17 | 55 | arrays, parsing, strings |

## Topics and why
| Topic | Feature in example.sh | Lines |
|---|---|---|
| arrays | `local -a guesses=( "$@" )`, looping over `"${guesses[@]}"` | 5, 11 |
| control_flow_conditionals | `if` / `elif` / `else` with `[[ ]]` and `(( ))` | 12, 15, 20, 26, 29, 30 |
| control_flow_loops | `for guess in ...` and the C-style `for (( i ... ))` | 11, 21 |
| error_handling | message to stderr (`>&2`) and `exit 1` after the game is over | 13-14, 16-17 |
| regular_expressions | `[[ $word =~ $guess ]]` and `[[ ! $masked_word =~ "_" ]]` | 20, 26 |
| strings | `${word//?/_}`, `${#word}`, `${word:i:1}`, `${masked_word:0:i}` | 8, 21-23 |
| text_formatting | `printf` with `%s` formats for the three output lines | 38 |

All seven topics already exist in `config.json` (regular_expressions is used by
2 other exercises, the others by 8 to 26).

## Results
- Only the `save-the-cow` entry changed: `git diff --stat` shows `config.json`
  with 10 insertions and 1 deletion (`"difficulty": 4` gained a comma). With
  that entry removed, the rest of the file is identical.
- `bin/configlet lint`: passes (`lint.txt`).
- `jq -e '.exercises.practice[] | select(.slug=="save-the-cow") | .topics | length > 0' config.json`: true.

## Environment notes
- `jq` and `bin/configlet` were installed on macOS with Homebrew and
  `bin/fetch-configlet`.
