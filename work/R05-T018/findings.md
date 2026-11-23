# Task R05-T018 Findings: Fix 'eliuds-eggs' metadata in config.json

## Student Information
- Name: ARYA PRAJAPATI
- Task ID: R05-T018
- Issue: #22

## Problem
In `config.json`, `eliuds-eggs` had no `topics` metadata defined (`"topics": null`).

## Solution & Justification
`eliuds-eggs` (counting bits in a number) is solved in Bash by repeatedly extracting the least significant bit (`number & 1`), right-shifting (`number >>= 1`), and accumulating the count in a `while (( number > 0 ))` loop.
Therefore, the topics chosen are:
- `bitwise_operations`
- `integers`
- `loops`

All three match standard topic names in the Bash track `config.json`.

## Comparison with other Difficulty-3 Exercises

| Exercise Slug | Difficulty | Test Count | Concepts & Topics |
|---|---|---|---|
| **`eliuds-eggs`** | 3 | 4 | Bitwise manipulation, integer shift, while loop (`bitwise_operations`, `integers`, `loops`) |
| **`collatz-conjecture`** | 3 | 6 | Conditionals, validation, integer math (`control_flow_conditionals`, `input_validation`, `integers`, `math`) |
| **`darts`** | 3 | 17 | Floating point / distance comparison (`control_flow_conditionals`, `math`) |
| **`square-root`** | 3 | 6 | Integer square root algorithms (`algorithms`, `math`) |

## Verification
- `jq '.exercises.practice[] | select(.slug=="eliuds-eggs").topics | length > 0' config.json` evaluates to `true`.
- `bin/validate_one_exercise exercises/practice/eliuds-eggs` passes all 4 tests.
