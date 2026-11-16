# Task R05-T036: Document Ways to Solve 'raindrops' (Issue #38)

## Overview & Objectives
Document two idiomatic Bash approaches for `exercises/practice/raindrops/` complying with track policies, the Google Shell Style Guide, and Exercism's approach schema:
1. **String concatenation (`string-concatenation`)**: Direct arithmetic evaluation and conditional string accumulation using default parameter expansion.
2. **Associative-array lookup (`associative-array`)**: Data-driven factor-to-sound mapping using Bash 4 associative arrays (`declare -A`) and ordered key iteration.

---

## Generated UUIDs (`bin/configlet uuid`)
Fresh, version 4 UUIDs generated via `bin/configlet uuid -n 2`:
- `string-concatenation`: `74aa019a-a9a0-41a9-87d8-34138b4ec874`
- `associative-array`: `36ff17ee-37e6-4212-82ac-a7f671ac054c`

---

## Directory Structure & Configuration

```text
exercises/practice/raindrops/.approaches/
├── associative-array/
│   ├── content.md
│   └── snippet.txt
├── config.json
├── introduction.md
└── string-concatenation/
    ├── content.md
    └── snippet.txt
```

### Approach Registry (`config.json`)
```json
{
  "introduction": {
    "authors": [
      "avbalotra"
    ]
  },
  "approaches": [
    {
      "uuid": "74aa019a-a9a0-41a9-87d8-34138b4ec874",
      "slug": "string-concatenation",
      "title": "String concatenation",
      "blurb": "Conditionally append raindrop sounds using arithmetic checks and default parameter expansion.",
      "authors": [
        "avbalotra"
      ]
    },
    {
      "uuid": "36ff17ee-37e6-4212-82ac-a7f671ac054c",
      "slug": "associative-array",
      "title": "Associative-array lookup",
      "blurb": "Map factors to sounds in an associative array and iterate through sorted keys.",
      "authors": [
        "avbalotra"
      ]
    }
  ]
}
```

---

## Snippets & Implementation Details

Each `snippet.txt` provides a complete, runnable Bash solution matching the exercise interface without Markdown code fences, conforming to Google Shell Style Guide rules and Exercism's 8-line snippet limit.

### 1. String Concatenation (`exercises/practice/raindrops/.approaches/string-concatenation/snippet.txt`)
```bash
#!/usr/bin/env bash
num=${1}
output=""
(( num % 3 == 0 )) && output+="Pling"
(( num % 5 == 0 )) && output+="Plang"
(( num % 7 == 0 )) && output+="Plong"
echo "${output:-${num}}"
```
- **Arithmetic Evaluation:** Uses native `(( num % factor == 0 ))` compound command.
- **Concatenation:** Appends sounds via `+=` operator without subshells.
- **Default Fallback:** Uses `${output:-${num}}` parameter expansion to return the original number when `output` is empty.

### 2. Associative-Array Lookup (`exercises/practice/raindrops/.approaches/associative-array/snippet.txt`)
```bash
#!/usr/bin/env bash
num=${1}
output=""
declare -A sounds=([3]="Pling" [5]="Plang" [7]="Plong")
for factor in 3 5 7; do
  (( num % factor == 0 )) && output+="${sounds[${factor}]}"
done
echo "${output:-${num}}"
```
- **Associative Mapping:** Decouples factor-to-sound rules into a hash map (`declare -A`).
- **Ordered Key Iteration:** Iterates over explicit keys (`3 5 7`) because Bash associative arrays do not guarantee insertion order.
- **Default Fallback:** Uses `${output:-${num}}` parameter expansion to output `${num}` when no factors match.

---

## Static Analysis Verification (`shellcheck -o all`)

Both snippets pass `shellcheck -o all` cleanly with zero warnings or style notices.

### String Concatenation
```bash
shellcheck -o all exercises/practice/raindrops/.approaches/string-concatenation/snippet.txt
```
*Output: (0 diagnostic messages — clean)*

### Associative Array
```bash
shellcheck -o all exercises/practice/raindrops/.approaches/associative-array/snippet.txt
```
*Output: (0 diagnostic messages — clean)*

---

## Bats Test Suite Verification (18/18 Tests Passed)

Each snippet was tested directly as `exercises/practice/raindrops/raindrops.sh` against all 18 test cases in `raindrops.bats`, followed by immediate index restoration (`git checkout -- exercises/practice/raindrops/raindrops.sh`).

### String Concatenation Test Run (`work/R05-T036/bats_string_concatenation.txt`)
```text
1..18
ok 1 the sound for 1 is 1
ok 2 the sound for 3 is Pling
ok 3 the sound for 5 is Plang
ok 4 the sound for 7 is Plong
ok 5 the sound for 6 is Pling as it has a factor 3
ok 6 2 to the power 3 does not make a raindrop sound as 3 is the exponent not the base
ok 7 the sound for 9 is Pling as it has a factor 3
ok 8 the sound for 10 is Plang as it has a factor 5
ok 9 the sound for 14 is Plong as it has a factor of 7
ok 10 the sound for 15 is PlingPlang as it has factors 3 and 5
ok 11 the sound for 21 is PlingPlong as it has factors 3 and 7
ok 12 the sound for 25 is Plang as it has a factor 5
ok 13 the sound for 27 is Pling as it has a factor 3
ok 14 the sound for 35 is PlangPlong as it has factors 5 and 7
ok 15 the sound for 49 is Plong as it has a factor 7
ok 16 the sound for 52 is 52
ok 17 the sound for 105 is PlingPlangPlong as it has factors 3, 5 and 7
ok 18 the sound for 3125 is Plang as it has a factor 5
```

### Associative Array Test Run (`work/R05-T036/bats_associative_array.txt`)
```text
1..18
ok 1 the sound for 1 is 1
ok 2 the sound for 3 is Pling
ok 3 the sound for 5 is Plang
ok 4 the sound for 7 is Plong
ok 5 the sound for 6 is Pling as it has a factor 3
ok 6 2 to the power 3 does not make a raindrop sound as 3 is the exponent not the base
ok 7 the sound for 9 is Pling as it has a factor 3
ok 8 the sound for 10 is Plang as it has a factor 5
ok 9 the sound for 14 is Plong as it has a factor of 7
ok 10 the sound for 15 is PlingPlang as it has factors 3 and 5
ok 11 the sound for 21 is PlingPlong as it has factors 3 and 7
ok 12 the sound for 25 is Plang as it has a factor 5
ok 13 the sound for 27 is Pling as it has a factor 3
ok 14 the sound for 35 is PlangPlong as it has factors 5 and 7
ok 15 the sound for 49 is Plong as it has a factor 7
ok 16 the sound for 52 is 52
ok 17 the sound for 105 is PlingPlangPlong as it has factors 3, 5 and 7
ok 18 the sound for 3125 is Plang as it has a factor 5
```

---

## Configlet Lint & Sync Verification

### 1. `bin/configlet fmt -e raindrops`
```text
Found 0 Concept Exercises and 100 Practice Exercises in /Users/atharavbalotra/bash/config.json
Looking for exercises that lack a formatted '.meta/config.json', '.approaches/config.json'
or '.articles/config.json' file...
The `raindrops` exercise config is already formatted!
```

### 2. `bin/configlet sync -e raindrops` (`work/R05-T036/configlet_sync.txt`)
```text
Updating cached 'problem-specifications' data...
Checking exercises...
The `raindrops` exercise has up-to-date docs, filepaths, metadata, and tests!
```

### 3. `bin/configlet lint` (`work/R05-T036/configlet_lint.txt`)
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

*(Note: Configlet 4.0.3 checks for track-level `docs/SIGN_UP_SNIPPET.txt`, which was verified locally without modifying any track docs outside Task 6 scope).*

---

## Clean Working Tree Verification

The user stub `exercises/practice/raindrops/raindrops.sh` remains completely untouched and clean.
Only files under `exercises/practice/raindrops/.approaches/` and `work/R05-T036/` are added.
