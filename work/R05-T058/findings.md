# R05-T058 — Fix `resistor-color-trio` metadata in `config.json`

## 1. Difficulty justification

| Exercise | Difficulty | Tests | Example lines | Key features |
|---|---|---|---|---|
| `resistor-color` | 2 | 4 | 22 | Single array lookup |
| `resistor-color-duo` | 2 | 10 | 35 | Two-digit concatenation, one loop |
| **`resistor-color-trio`** | **3** | **13** | **51** | **Two arrays, two loops (`for`+`while`), exponent math, metric prefix scaling, error handling** |
| `collatz-conjecture` | 3 | 8 | 18 | Single `while` loop, simple arithmetic |
| `sieve` | 3 | 5 | 23 | Nested loops, array filtering |
| `acronym` | 3 | 7 | 7 | String manipulation, `tr`/`sed` |

**Conclusion:** Difficulty 3 is correct. `resistor-color-trio` is substantially more complex than its difficulty-2 siblings and comparable to other difficulty-3 exercises.

## 2. Topics analysis

The reference solution (`exercises/practice/resistor-color-trio/.meta/example.sh`) uses:

| Bash feature | Where in example.sh | Mapped topic |
|---|---|---|
| Indexed arrays `COLORS`, `PREFIXES` | Lines 5–6, 7 | `arrays` |
| `if/else` for error handling (`die`) | Lines 9–11, 25–32 | `control_flow_conditionals` |
| `for` loop in `indexof()` | Lines 14–19 | `control_flow_loops` |
| `while` loop in `with_units()` | Lines 34–39 | `control_flow_loops` |
| Exponent arithmetic `$(( ... * 10 ** ... ))` | Line 46 | `math` |

### Change made

Added `"control_flow_loops"` to the topics array (alphabetically sorted):

```json
"topics": [
  "arrays",
  "control_flow_conditionals",
  "control_flow_loops",
  "math"
]
```

## 3. Validation results

- ✅ `jq . config.json > /dev/null` — JSON syntax valid
- ✅ `jq -e '.exercises.practice[] | select(.slug=="resistor-color-trio") | .topics | length > 0'` — topics array has 4 entries
- ✅ `bin/configlet lint` — only pre-existing track-wide `docs/SIGN_UP_SNIPPET.txt` warning (not related to `resistor-color-trio`)
- ✅ Only the `resistor-color-trio` entry was modified; no other exercises affected
