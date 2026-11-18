<!-- markdownlint-disable MD013 MD033 -->
# Task R05-T040: Add 'high-scores' Exercise to the Bash Track (Issue #42)

## Overview & Objectives

The `high-scores` exercise exists in `problem-specifications` with 12 canonical test cases for managing a game player's high score list (`latest`, `personalBest`, `personalTopThree`, `scores`, and the immutable `After` variants). It was previously listed in `exercises.foregone` and missing from the Bash track.

This task ports `high-scores` to the Bash track as a complete practice exercise following `POLICIES.md`, the Google Shell Style Guide, and canonical Exercism conventions:

- Scaffolded via `bin/configlet create --practice-exercise high-scores --difficulty 2`.
- Integrated into root `config.json` under difficulty 2 with topics `["arrays", "sorting"]`, and removed from `exercises.foregone`.
- Designed a clean, idiomatic Bash CLI interface supporting subcommands and variable-length score lists.
- Authored reference solution `.meta/example.sh` and stub `high_scores.sh`, both passing `shellcheck -o all` with 0 warnings.
- Created `.meta/template.j2` and generated `high_scores.bats` via `bin/generate_tests --no-pull high-scores`.
- Validated with `bin/validate_one_exercise`, `bin/configlet lint`, and `bin/configlet sync`.

Exercism Community Discussion & Forum: [Exercism Bash Track Forum](https://forum.exercism.org/c/programming/bash/70)

---

## 1. Problem Specifications & Existing Track Conventions

### Canonical Metadata (`metadata.toml`)

- **Title:** High Scores
- **Blurb:** Manage a player's High Score list.
- **Source:** Tribute to the eighties' arcade game Frogger

### Canonical Test Cases (`canonical-data.json`)

All 12 canonical test cases were inspected from `problem-specifications/exercises/high-scores/canonical-data.json`:

1. `1035eb93-2208-4c22-bab8-fef06769a73c`: List of scores (`property: scores`)
2. `6aa5dbf5-78fa-4375-b22c-ffaa989732d2`: Latest score (`property: latest`)
3. `b661a2e1-aebf-4f50-9139-0fb817dd12c6`: Personal best (`property: personalBest`)
4. `3d996a97-c81c-4642-9afc-80b80dc14015`: Personal top three from a list of scores (`property: personalTopThree`)
5. `1084ecb5-3eb4-46fe-a816-e40331a4e83a`: Personal top highest to lowest (`property: personalTopThree`)
6. `e6465b6b-5a11-4936-bfe3-35241c4f4f16`: Personal top when there is a tie (`property: personalTopThree`)
7. `f73b02af-c8fd-41c9-91b9-c86eaa86bce2`: Personal top when there are less than 3 (`property: personalTopThree`)
8. `16608eae-f60f-4a88-800e-aabce5df2865`: Personal top when there is only one (`property: personalTopThree`)
9. `2df075f9-fec9-4756-8f40-98c52a11504f`: Latest score after personal top scores (`property: latestAfterTopThree`)
10. `809c4058-7eb1-4206-b01e-79238b9b71bc`: Scores after personal top scores (`property: scoresAfterTopThree`)
11. `ddb0efc0-9a86-4f82-bc30-21ae0bdc6418`: Latest score after personal best (`property: latestAfterBest`)
12. `6a0fd2d1-4cc4-46b9-a5bb-2fb667ca2364`: Scores after personal best (`property: scoresAfterBest`)

### Existing Track Conventions Inspected

- **CLI Subcommand Conventions:** Inspected `allergies` (`<score> list`, `<score> allergic_to <item>`) and `resistor-color` (`code <color>`, `colors`). For `high-scores`, passing the operation as the first positional parameter (`high_scores.sh <operation> [scores...]`) provides a natural and scalable command dispatch.
- **Array Output Formats:** Inspected `all-your-base`, `allergies`, and `forth`, which output whitespace-separated values on standard output (`assert_output "{{ case['expected'] | join(' ') }}"`).

---

## 2. CLI Design Specification

The CLI interface takes the operation as the first argument, followed by the scores:

```bash
high_scores.sh <operation> [score1 score2 ...]
```

### Supported Operations & Canonical Property Mapping

| Canonical Property | CLI Invocation | Output Format | Description |
| :--- | :--- | :--- | :--- |
| `scores` | `high_scores.sh scores 30 50 20 70` | `30 50 20 70` | Outputs the original list of scores space-separated. |
| `latest` | `high_scores.sh latest 100 0 90 30` | `30` | Outputs the last added score. |
| `personalBest` | `high_scores.sh personalBest 40 100 70` | `100` | Outputs the highest score. |
| `personalTopThree` | `high_scores.sh personalTopThree 10 30 90 30 100 ...` | `100 90 70` | Outputs up to top 3 scores in descending order. |
| `latestAfterTopThree` | `high_scores.sh personalTopThree ...`<br>`high_scores.sh latest ...` | `30` | Tests that personal top calculation does not mutate scores list. |
| `scoresAfterTopThree` | `high_scores.sh personalTopThree ...`<br>`high_scores.sh scores ...` | `30 50 20 70` | Tests that personal top calculation does not mutate scores list. |
| `latestAfterBest` | `high_scores.sh personalBest ...`<br>`high_scores.sh latest ...` | `30` | Tests that personal best calculation does not mutate scores list. |
| `scoresAfterBest` | `high_scores.sh personalBest ...`<br>`high_scores.sh scores ...` | `20 70 15 25 30` | Tests that personal best calculation does not mutate scores list. |

Both camelCase (`personalBest`, `personalTopThree`) and snake_case (`personal_best`, `personal_top_three`) are supported. Argument parsing also supports space-delimited string arguments as well as separate positional arguments.

---

## 3. Implementation Details

### Track Configuration (`config.json`)

- Added `high-scores` to `exercises.practice` in alphabetical order under difficulty 2:

  ```json
  {
    "slug": "high-scores",
    "name": "High Scores",
    "uuid": "e15e6cc7-8b3c-4e55-b26b-697ad6d7c0df",
    "practices": [],
    "prerequisites": [],
    "difficulty": 2,
    "topics": [
      "arrays",
      "sorting"
    ]
  }
  ```

- Removed `"high-scores"` from `exercises.foregone`.

### Reference Solution (`.meta/example.sh`)

- Uses pure Bash arrays, negative index expansion `${list[-1]}` for `latest`, an accumulator loop for `personal_best`, and an in-memory descending insertion sort for `personal_top_three` to avoid SC2312 pipeline masking warnings and external process overhead.
- Passes `shellcheck -o all` with 0 warnings.

### Stub File (`high_scores.sh`)

- Conforms to standard Bash track practice stub template with initial documentation and comments.
- Passes `shellcheck -o all` with 0 warnings.

### Test Generator (`.meta/template.j2` & `high_scores.bats`)

- Created Jinja2 template rendering all 12 test cases with standard skip directives.
- Executed `bin/generate_tests --no-pull high-scores` to generate `high_scores.bats`.

---

## 4. Verification Evidence

### 4.1 Exercise Validator (`bin/validate_one_exercise exercises/practice/high-scores`)

Recorded in `work/R05-T040/validator_output.txt`:

```text
Processing high-scores
1..12
ok 1 List of scores
ok 2 Latest score
ok 3 Personal best
ok 4 Personal top three from a list of scores
ok 5 Personal top highest to lowest
ok 6 Personal top when there is a tie
ok 7 Personal top when there are less than 3
ok 8 Personal top when there is only one
ok 9 Latest score after personal top scores
ok 10 Scores after personal top scores
ok 11 Latest score after personal best
ok 12 Scores after personal best
Updated 1 path from the index
```

**Result:** All 12/12 tests pass cleanly, and the stub file was restored cleanly by the validation cleanup trap.

### 4.2 Configlet Lint (`bin/configlet lint`)

Recorded in `work/R05-T040/configlet_lint.txt`:

```text
The lint command is under development.
To check your track using the latest linting rules,
please regularly update configlet and re-run this command.

Basic linting finished successfully:
- config.json exists and is valid JSON
- config.json has these valid fields:
    language, slug, active, blurb, version, status, online_editor, key_features, tags
- Every concept has the required .md files
- Every concept has a valid links.json file
- Every concept has a valid .meta/config.json file
- Every concept exercise has the required .md files
- Every concept exercise has a valid .meta/config.json file
- Every practice exercise has the required .md files
- Every practice exercise has a valid .meta/config.json file
- Every approach and article is valid
- Required track docs are present
- Required shared exercise docs are present
```

**Result:** Clean pass (0 errors, 0 warnings).

### 4.3 Configlet Sync (`bin/configlet sync -e high-scores`)

Recorded in `work/R05-T040/configlet_sync.txt`:

```text
Updating cached 'problem-specifications' data...
Checking exercises...
The `high-scores` exercise has up-to-date docs, filepaths, metadata, and tests!
```

**Result:** 100% synchronized with problem-specifications.

### 4.4 ShellCheck (`shellcheck -o all`)

Recorded in `work/R05-T040/shellcheck.txt`:

```bash
shellcheck -o all exercises/practice/high-scores/high_scores.sh exercises/practice/high-scores/.meta/example.sh
```

**Result:** 0 diagnostic messages (clean pass).
