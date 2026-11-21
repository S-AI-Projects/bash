# R05-T048 — Findings: intergalactic-transmission metadata

Student: Hemant Gandhe (E26B07F0874)
Task: R05-T048, Issue 49 in S-AI-Projects/bash
Branch: student/e26b07f0874/R05-T048, from main 9567ba5

## Before

```json
{
  "slug": "intergalactic-transmission",
  "name": "Intergalactic Transmission",
  "uuid": "b1874a8b-ebc7-4a1b-802f-8f0a6feaa59d",
  "practices": [],
  "prerequisites": [],
  "difficulty": 5
}
```

No `topics` key at all. Blurb in `.meta/config.json`: "Add parity bits to a message for transmission".

## After (only this entry changed)

```json
"topics": [
  "bitwise_operations",
  "parity"
]
```

Full diff: `git diff config.json` — 5 insertions, 1 deletion, only the intergalactic-transmission entry.

## Why these topics

- `bitwise_operations`: already used in this track for allergies, secret-handshake and variable-length-quantity. The example uses bit shifts `>>`, masks `& 1`, and base literals `16#…` / `2#…` to add and check an even parity bit.
- `parity`: the exercise is specifically about adding/checking a parity bit in `transmit_sequence` and `decode_message`. It was not previously used in this track, so it was verified by running configlet lint (see below) rather than assumed.

Topics are alphabetically sorted, as configlet expects.

## Comparison with 3 other difficulty-5 exercises

All 15 difficulty-5 practice exercises in the track:
atbash-cipher, crypto-square, diffie-hellman, flower-field, food-chain, grep, intergalactic-transmission, minesweeper, rational-numbers, robot-simulator, run-length-encoding, say, simple-cipher, tournament, transpose.

| Exercise | Difficulty | Topics | Tests (.bats @test) | Example.sh lines |
|---|---|---|---|---|
| intergalactic-transmission (target) | 5 | bitwise_operations, parity (added) | 26 | 72 |
| atbash-cipher | 5 | cryptography, pattern_matching, strings | 14 | 14 |
| crypto-square | 5 | arrays, cryptography, math, transformation | 8 | 29 |
| diffie-hellman | 5 | math, randomness | 6 | 40 |

Full jq output: `jq-comparison.txt` in this folder.

Reading: intergalactic-transmission is the heaviest of the four (26 tests vs 6–14; 72 example lines vs 14–40), consistent with difficulty 5, and its distinctive bit-level parity work was not captured by any topic before this change. The comparators all carry 2–4 topics.

Bash features in the example: arithmetic `$(( ))`, bit shifts `>>`, bitwise `& 1`, base literals `16#…` / `2#…`, substring `${var:offset:len}`, `${bits//0/}`, `${#var}`, `local -a` arrays, `printf "0x%02x"`, C-style `for (( ))`, `[[ ]]` tests.

## Checks

- `jq -e '.exercises.practice[] | select(.slug=="intergalactic-transmission") | .topics | length > 0' config.json` → `true`
- `bin/validate_one_exercise exercises/practice/intergalactic-transmission` → 26/26 tests pass, exit 0
- configlet lint → see `configlet-lint.txt`
  - configlet 4.0.1 (downloaded directly as `configlet_4.0.1_linux_x86-64.tar.gz`): "Basic linting finished successfully", exit 0. No complaint about `parity`.
  - Note: `bin/fetch-configlet` failed at the time with GitHub API 403 rate limit exceeded (reset 21:52 UTC, 22 Nov 2026). An older 4.0.0-beta.13 binary was also tried: it reported only the pre-existing "exercises.concept key is missing" message, which also appears on clean main, so it is not caused by this change.
  - bats and shellcheck were installed via apt for the validator (`Bats 1.10.0`).

## PR

- Base: S-AI-Projects/bash, head: student/e26b07f0874/R05-T048
- Commit the code change (config.json) plus this work/R05-T048/ folder.
- For a later upstream PR, create a second branch containing only the code change (no work/ folder).
