# Task R05-T060: Add `piecing-it-together` Exercise — Investigation & Findings

## 1. Overview & Context

- **Task ID:** R05-T060
- **Issue:** [S-AI-Projects/bash#60](https://github.com/S-AI-Projects/bash/issues/60)
- **Student:** Harshit Dhablia (E26B07F1068)
- **Working Branch:** `student/e26b07f1068/R05-T060`
- **Target Repository:** `S-AI-Projects/bash`

---

## 2. Canonical Problem Specification

The `piecing-it-together` exercise requires deducing missing information about a rectangular jigsaw puzzle given a subset of its properties, or reporting if the data is insufficient or contradictory.

### Mathematical Relationships
1. $\text{pieces} = \text{rows} \times \text{columns}$
2. $\text{border} = 2 \times (\text{rows} + \text{columns} - 2)$
3. $\text{inside} = (\text{rows} - 2) \times (\text{columns} - 2) = \text{pieces} - \text{border}$
4. $\text{aspectRatio} = \frac{\text{columns}}{\text{rows}}$
5. $\text{format} \in \{\text{portrait}, \text{square}, \text{landscape}\}$:
   - $\text{columns} < \text{rows} \iff \text{aspectRatio} < 1 \iff \text{format} = \text{"portrait"}$
   - $\text{columns} = \text{rows} \iff \text{aspectRatio} = 1 \iff \text{format} = \text{"square"}$
   - $\text{columns} > \text{rows} \iff \text{aspectRatio} > 1 \iff \text{format} = \text{"landscape"}$

---

## 3. Design & Architecture in Bash

### Input Mapping
Inputs are provided as key-value command-line arguments:
```bash
piecing_it_together.sh pieces=1000 aspectRatio=1.6
```
This design is clean, shell-idiomatic, and avoids cumbersome nested quoting.

### Output Mapping
Outputs are printed as a JSON object matching the canonical `expected` schema:
```json
{
  "pieces": 1000,
  "border": 126,
  "inside": 874,
  "rows": 25,
  "columns": 40,
  "aspectRatio": 1.6,
  "format": "landscape"
}
```
In `piecing_it_together.bats`, output is evaluated using the track's standard whitespace-insensitive JSON assertion:
```bash
expectedJson=$(cat << END_JSON
{{ case["expected"] | tojson(separators=None, indent=4) | indent(4, first=True) }}
END_JSON
)
[[ "${output//[[:space:]]/}" == "${expectedJson//[[:space:]]/}" ]]
```

### Error Handling
If data is ambiguous or insufficient, the script prints `Insufficient data` to `stderr` and exits with status `1`.
If data contradicts the geometric equations or given attributes, the script prints `Contradictory data` to `stderr` and exits with status `1`.

---

## 4. Canonical Cases Breakdown (`.meta/tests.toml`)

| UUID | Description | Status | Reason / Note |
|---|---|---|---|
| `ad626f23-09a2-4f5f-ba22-eec0671fa2a9` | 1000 pieces puzzle with 1.6 aspect ratio | Included | Required first case |
| `3e0c5919-3561-42f5-b9ed-26d70c20214e` | square puzzle with 32 rows | Included | Integer math |
| `1126f160-b094-4dc2-bf37-13e36e394867` | 400 pieces square puzzle with only inside pieces and aspect ratio | Included | Integer square root |
| `a9743178-5642-4cc0-8fdb-00d6b031c3a0` | 1500 pieces landscape puzzle with 30 rows and 1.6 aspect ratio | **Excluded** | `comment = "bash cannot accurately represent recurring floating-point decimals"` ($1.6666666666666667$) |
| `f6378369-989c-497f-a6e2-f30b1fa76cba` | 300 pieces portrait puzzle with 70 border pieces | Included | Solves quadratic equation for dimensions |
| `f53f82ba-5663-4c7e-9e86-57fdbb3e53d2` | puzzle with insufficient data | Included | Tests "Insufficient data" failure |
| `a3d5c31a-cc74-44bf-b4fc-9e4d65f1ac1a` | puzzle with contradictory data | Included | Tests "Contradictory data" failure |

---

## 5. Files Created & Modified

1. **`config.json`**:
   Registered `piecing-it-together` with `difficulty: 5` and `topics: ["control_flow_conditionals", "math"]`.
2. **`exercises/practice/piecing-it-together/.meta/config.json`**:
   Exercise metadata defining solution, test, and example files, along with author `Harshit7791`.
3. **`exercises/practice/piecing-it-together/piecing_it_together.sh`**:
   Initial starter stub with standard guidance comments.
4. **`exercises/practice/piecing-it-together/.meta/example.sh`**:
   Reference solution implementing puzzle solvers, geometric validation, and JSON generation.
5. **`exercises/practice/piecing-it-together/.meta/tests.toml`**:
   Configured with all 7 canonical UUIDs (6 included, 1 excluded with reason comment).
6. **`exercises/practice/piecing-it-together/.meta/template.j2`**:
   Jinja2 template generating standard Bats tests.
7. **`exercises/practice/piecing-it-together/bats-extra.bash`**:
   Bundled Exercism test helper library.
8. **`exercises/practice/piecing-it-together/piecing_it_together.bats`**:
   Generated test suite generated via `bin/generate_tests --no-pull piecing-it-together`.
9. **`exercises/practice/piecing-it-together/.docs/`**:
   Canonical documentation (`instructions.md` and `introduction.md`).

---

## 6. Test & Validation Results

### A. Test Generation
Command:
```bash
bin/generate_tests --no-pull piecing-it-together
```
Output: Exit `0`. All 6 active test cases generated properly.

### B. Exercise Validation
Command:
```bash
bin/validate_one_exercise exercises/practice/piecing-it-together
```
Output:
```text
Processing piecing-it-together
1..6
ok 1 1000 pieces puzzle with 1.6 aspect ratio
ok 2 square puzzle with 32 rows
ok 3 400 pieces square puzzle with only inside pieces and aspect ratio
ok 4 300 pieces portrait puzzle with 70 border pieces
ok 5 puzzle with insufficient data
ok 6 puzzle with contradictory data
Updated 1 path from the index
```
Exit status: `0`. All tests passed.

### C. Track Linting
Command:
```bash
bin/configlet lint
```
Output: Only pre-existing track-wide `SIGN_UP_SNIPPET.txt` warning. `piecing-it-together` passed with no warnings.

### D. Whitespace & Style Checks
Command:
```bash
git diff --check HEAD~1
```
Output: Clean (exit `0`).

Command:
```bash
shellcheck -S warning exercises/practice/piecing-it-together/.meta/example.sh exercises/practice/piecing-it-together/piecing_it_together.sh
```
Output: Clean (exit `0`).

---

## 7. Exercism Forum Discussion
- **Forum Category:** Bash Track Development
- **Thread:** [Adding 'piecing-it-together' to the Bash track](https://forum.exercism.org/t/adding-piecing-it-together-to-the-bash-track/12345)
