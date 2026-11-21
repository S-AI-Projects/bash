# R05-T046: approaches articles for 'isogram'

## What was added (all under exercises/practice/isogram/.approaches/)
| File | Purpose |
|---|---|
| `config.json` | introduction authors + two approaches (uuid, slug, title, blurb, authors); UUIDs are random v4 values, checked not to collide with any existing approach uuid |
| `introduction.md` | general guidance (case does not matter, only letters count), both approaches with their code, and a "Which approach to use?" section |
| `lowercase-and-loop/` | `content.md` + `snippet.txt`: lowercase with `${1,,}`, loop over characters, keep a `seen` string, stop at the first repeat |
| `tr-sort-uniq/` | `content.md` + `snippet.txt`: `tr -cd '[:alpha:]' \| fold -w1 \| sort \| uniq -d`; empty output means isogram |

The layout and wording follow `exercises/practice/leap/.approaches`.

## Checks (`check_snippets.sh`, output in `check_snippets.out`)
- The reference `.meta/example.sh` and both snippets each pass all 14 tests of `isogram.bats` (the snippet is copied to `isogram.sh` in a temp dir).
- Each snippet is at most 8 lines, and its text appears verbatim in its own `content.md` and in `introduction.md`.
- Slugs match folders, uuids are v4 and unique in the track.
- Negative control: with `uniq -d` deliberately changed to `uniq -u`, the script reported 5 failing tests and the article mismatch, then passed again once restored.
- Every example in the articles' tables (letters after `tr`, after `sort`, what `uniq -d` prints, letters seen by the loop) was reproduced by running the commands. Doing this found one wrong row (`up-to-date` needs `uptoda`), which is fixed.

## Timing (`timing.out`, 300 runs each, median)
| phrase | lowercase-and-loop | tr-sort-uniq | reference example.sh |
|---|---|---|---|
| `Emily Jung Schwartzkopf` | 1.73 ms | 4.97 ms | 1.76 ms |
| the quick brown fox ... lazy dog | 1.74 ms | 5.38 ms | 1.79 ms |

This supports the articles' statement that the pipeline costs more because it starts several processes. Both are fast enough for this exercise.

## Not run in the environment where this was written
`bin/configlet lint` (configlet could not be downloaded), and real `bats` (a small stand-in was used for the snippet runs). Run both locally before opening the PR:
`bin/configlet lint && bash work/R05-T046/check_snippets.sh`.
