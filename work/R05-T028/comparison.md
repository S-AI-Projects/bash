# Difficulty-2 Exercise Comparison (R05-T028)

Comparing `line-up` against three other difficulty-2 exercises in the track:

| Exercise | Difficulty | Test Count | Example Lines | Topics | Bash Features Used |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `line-up` | 2 | 25 | 17 | `control_flow_conditionals`, `pattern_matching`, `strings`, `text_formatting` | `case` statement, pattern matching on numerical suffixes (`*11\|*12\|*13`, `*1`, `*2`, `*3`), string interpolation, formatted output with `printf` |
| `raindrops` | 2 | 19 | 18 | `control_flow_conditionals`, `input_validation`, `strings` | Arithmetic evaluation `(( n % 3 == 0 ))`, string concatenation `result+=...`, `if/else` |
| `hamming` | 2 | 9 | 16 | `control_flow_loops`, `string_comparison` | Argument length validation `${#str}`, character indexing `${str:i:1}`, loop counter arithmetic |
| `pangram` | 2 | 10 | 12 | `string_transformation`, `strings` | Uppercase expansion `${1^^}`, pattern matching with wildcards `[[ $str != *$char* ]]`, alphabet iteration |

## JQ Extraction Command
```bash
jq -r '.exercises.practice[] | select(.slug as $s | ["line-up", "raindrops", "hamming", "pangram"] | index($s)) | {slug: .slug, difficulty: .difficulty, topics: .topics}' config.json
```
