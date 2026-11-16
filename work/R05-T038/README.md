<!-- markdownlint-disable MD013 -->
# Task R05-T038: Fix 'resistor-color' Metadata in config.json (Issue #40)

## Overview & Objectives

`config.json` previously configured `'resistor-color'` at difficulty 2 with no `topics` entry (`topics: null`), even though the exercise is an introductory array index lookup and listing problem. This task restores canonical metadata in root `config.json` for `'resistor-color'` by populating its `topics` array with `["arrays"]`, backed by comprehensive `jq` queries and structural comparisons across difficulty-2 exercises in the Exercism Bash track.

---

## 1. Inspection & Track Config Conventions

### 1.1 Resistor-Color Baseline Entry in `config.json`

Prior to update, the entry in `config.json` (lines 218–225) lacked the `topics` key:

```json
{
  "slug": "resistor-color",
  "name": "Resistor Color",
  "uuid": "93e9a833-d9d2-4d73-b559-2396b8f76446",
  "practices": [],
  "prerequisites": [],
  "difficulty": 2
}
```

### 1.2 Exercise Implementation & Tests Analysis

- **Reference Example (`exercises/practice/resistor-color/.meta/example.sh`):**
  - **Line count:** 22 lines.
  - **Bash features used:**
    - Readonly indexed array declaration: `readonly Colors=( black brown red orange yellow green blue violet grey white )`
    - Array expansion: `"${Colors[@]}"`
    - Array index expansion: `"${!Colors[@]}"`
    - Array element lookup by index: `"${Colors[idx]}"`
    - Dispatch `case "$1" in` (`colors` vs `code`)
    - For loop iteration over array indices: `for idx in "${!Colors[@]}"; do ... done`
    - Equality check: `if [[ "${Colors[idx]}" == "$2" ]]; then`
    - Output formatting: `printf '%s\n'` and `echo`
- **Test Suite (`exercises/practice/resistor-color/resistor_color.bats`):**
  - **Total `@test` cases:** 4 test cases
    1. `@test "Color codes -> Black"` (validates `resistor_color.sh code black` -> `"0"`)
    2. `@test "Color codes -> White"` (validates `resistor_color.sh code white` -> `"9"`)
    3. `@test "Color codes -> Orange"` (validates `resistor_color.sh code orange` -> `"3"`)
    4. `@test "Colors"` (validates `resistor_color.sh colors` -> 10 lines in array order)

### 1.3 Track Config Conventions (`POLICIES.md` & Exercism Track Specification)

- `difficulty`: Integer from 1 to 10 (difficulty 2 corresponds to easy / introductory practice).
- `practices`: Array of concept slugs practiced (conventionally empty `[]` across all practice exercises in the Bash track).
- `prerequisites`: Array of prerequisite concept slugs (conventionally empty `[]` across all practice exercises in the Bash track).
- `topics`: Array of canonical topic tags matching Exercism taxonomies.

### 1.4 Track-Canonical Topic & Practice Vocabulary Checks

Run via `jq` across root `config.json`:

```bash
# Verify all existing topics across config.json
jq '[.exercises.practice[].topics? // empty] | flatten | unique' config.json
```

Output:

```json
[
  "algorithms",
  "arrays",
  "associative_arrays",
  "base_conversion",
  "bitwise_operations",
  "boolean_logic",
  "conditionals",
  "control_flow_conditionals",
  "control_flow_loops",
  "cryptography",
  "dates",
  "equality",
  "error_handling",
  "external_commands",
  "filtering",
  "games",
  "input_validation",
  "integers",
  "logic",
  "loops",
  "math",
  "number_comparison",
  "parsing",
  "pattern_matching",
  "randomness",
  "recursion",
  "regexp",
  "regular_expressions",
  "sorting",
  "string_comparison",
  "string_transformation",
  "strings",
  "text_formatting",
  "transformation",
  "transforming",
  "variables"
]
```

```bash
# Verify practices and prerequisites across practice exercises
jq '[.exercises.practice[] | select((.practices | length > 0) or (.prerequisites | length > 0))] | length' config.json
# Output: 0
```

This confirms `arrays` is a valid, track-canonical topic tag, and all practice exercises have empty arrays for `practices` and `prerequisites`.

---

## 2. `jq` Comparison Across Difficulty-2 Exercises

### 2.1 Listing All Difficulty-2 Exercises in `config.json`

Command:

```bash
jq '[.exercises.practice[] | select(.difficulty == 2) | {slug, name, difficulty, topics, practices, prerequisites}]' config.json
```

Total difficulty-2 exercises found: 19 (`allergies`, `armstrong-numbers`, `difference-of-squares`, `error-handling`, `grains`, `hamming`, `house`, `largest-series-product`, `leap`, `line-up`, `pangram`, `raindrops`, `resistor-color`, `resistor-color-duo`, `rna-transcription`, `scrabble-score`, `secret-handshake`, `series`, `sublist`).

### 2.2 Difficulty-2 Exercises Using Arrays

Command:

```bash
jq '[.exercises.practice[] | select(.difficulty == 2 and (.topics[]? == "arrays")) | {slug, difficulty, topics}]' config.json
```

Output:

```json
[
  {
    "slug": "allergies",
    "difficulty": 2,
    "topics": [
      "arrays",
      "bitwise_operations"
    ]
  },
  {
    "slug": "house",
    "difficulty": 2,
    "topics": [
      "arrays",
      "control_flow_conditionals"
    ]
  },
  {
    "slug": "resistor-color-duo",
    "difficulty": 2,
    "topics": [
      "arrays",
      "control_flow_conditionals"
    ]
  }
]
```

### 2.3 Exact Comparison Query

Comparing `'resistor-color'` specifically against **`resistor-color-duo`** and 2 other difficulty-2 exercises (`allergies` and `house`):

```bash
jq '[.exercises.practice[] | select(.slug as $s | ["resistor-color", "resistor-color-duo", "allergies", "house"] | index($s)) | {slug, difficulty, topics, practices, prerequisites}]' config.json
```

Output:

```json
[
  {
    "slug": "allergies",
    "difficulty": 2,
    "topics": [
      "arrays",
      "bitwise_operations"
    ],
    "practices": [],
    "prerequisites": []
  },
  {
    "slug": "house",
    "difficulty": 2,
    "topics": [
      "arrays",
      "control_flow_conditionals"
    ],
    "practices": [],
    "prerequisites": []
  },
  {
    "slug": "resistor-color",
    "difficulty": 2,
    "topics": [
      "arrays"
    ],
    "practices": [],
    "prerequisites": []
  },
  {
    "slug": "resistor-color-duo",
    "difficulty": 2,
    "topics": [
      "arrays",
      "control_flow_conditionals"
    ],
    "practices": [],
    "prerequisites": []
  }
]
```

---

## 3. Comparison Table (Difficulty-2 Practice Exercises)

| Slug | Difficulty | Topics | Practices | Prerequisites | `@test` Cases (.bats) | Lines (.meta/example.sh) | Bash Features Used |
| :--- | :---: | :--- | :---: | :---: | :---: | :---: | :--- |
| **`resistor-color`** | 2 | `["arrays"]` | `[]` | `[]` | 4 | 22 | Readonly indexed array declaration (`readonly Colors=(...)`), array expansion (`"${Colors[@]}"`), index expansion (`"${!Colors[@]}"`), array indexing (`"${Colors[idx]}"`), `case` statement, `for` loop, `if [[ ... ]]`, `printf`, `echo` |
| **`resistor-color-duo`** | 2 | `["arrays", "control_flow_conditionals"]` | `[]` | `[]` | 10 | 35 | Indexed array (`colors=(...)`), index expansion (`"${!colors[@]}"`), element indexing (`${colors[i]}`), helper function with locals, conditional tests (`[[ ... ]]`, `[[ -n ... ]]`), stderr redirection (`>&2`), return codes, loop over positional parameters (`for color in "$1" "$2"`), parameter expansion prefix stripping (`${result#0}`) |
| **`allergies`** | 2 | `["arrays", "bitwise_operations"]` | `[]` | `[]` | 50 | 72 | Indexed array (`allergens=(...)`), array append (`allergies+=( ... )`), array index expansion (`"${!allergens[@]}"`), array indexing (`${allergens[i]}`), array join (`"${allergies[*]}"`), bitwise shifts/masks in arithmetic evaluation (`(( (code & (1 << idx)) != 0 ))`), parameter expansion (`${0##*/}`), `case` statement, argument checking |
| **`house`** | 2 | `["arrays", "control_flow_conditionals"]` | `[]` | `[]` | 18 | 42 | Array declaration (`declare -a items that`), array append operator (`+=`), array indexing (`"${items[n]}"`, `"${items[n-1]}"`), arithmetic evaluation range checking (`((1 <= start && start <= 12))`), C-style for loops (`for ((i = ...; ...; ...))`), `printf` formatting |

### Exercise Progression Rationale

The comparison clearly illuminates the intentional curricular progression across the resistor color family in the Bash track:

1. **`resistor-color` (Difficulty 2, `topics: ["arrays"]`):** Introduces fundamental array definitions, array traversal, and indexing by looking up a single color or listing all colors.
2. **`resistor-color-duo` (Difficulty 2, `topics: ["arrays", "control_flow_conditionals"]`):** Builds on arrays by introducing multi-value arguments, conditional argument handling (truncating to 2 colors), error returns on invalid colors, and leading zero handling.
3. **`resistor-color-trio` (Difficulty 3, `topics: ["arrays", "control_flow_conditionals", "math"]`):** Extends duo by introducing metric unit arithmetic scaling (ohms, kiloohms, megaohms, gigaohms).

Populating `'resistor-color'` with `topics: ["arrays"]` aligns its metadata perfectly with both its implementation and its track progression context.

---

## 4. Root `config.json` Modification

Only the `'resistor-color'` entry in root `config.json` was updated.

### `git diff config.json`

```diff
diff --git a/config.json b/config.json
index c8ce39f..bd2323d 100644
--- a/config.json
+++ b/config.json
@@ -221,7 +221,10 @@
         "uuid": "93e9a833-d9d2-4d73-b559-2396b8f76446",
         "practices": [],
         "prerequisites": [],
-        "difficulty": 2
+        "difficulty": 2,
+        "topics": [
+          "arrays"
+        ]
       },
       {
         "slug": "resistor-color-duo",
```

Verification confirms **0** other modifications or formatting diffs anywhere else in `config.json`.

---

## 5. Verification & Lint Checks

### 5.1 Configlet Lint (`bin/configlet lint`)

Recorded in `work/R05-T038/configlet_lint.txt`:

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

### 5.2 Configlet Sync (`bin/configlet sync -e resistor-color`)

Recorded in `work/R05-T038/configlet_sync.txt`:

```text
Updating cached 'problem-specifications' data...
Checking exercises...
The `resistor-color` exercise has up-to-date docs, filepaths, metadata, and tests!
```

**Result:** 100% synchronized with problem-specifications.

### 5.3 Bats Test Suite Verification

Executing `bats resistor_color.bats` against the reference implementation (`.meta/example.sh`):

```text
1..4
ok 1 Color codes -> Black
ok 2 Color codes -> White
ok 3 Color codes -> Orange
ok 4 Colors
```

**Result:** All 4/4 test cases pass cleanly.
