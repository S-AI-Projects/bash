# Introduction

To solve the Raindrops exercise in Bash, the primary objective is to convert an integer into a string according to whether it is evenly divisible by 3, 5, and 7:
- If divisible by 3, add `"Pling"`
- If divisible by 5, add `"Plang"`
- If divisible by 7, add `"Plong"`
- If not divisible by 3, 5, or 7, return the original number as a string.

There are two primary idiomatic approaches in Bash:
1. **String concatenation**: Directly checking each factor with arithmetic evaluations and conditionally appending sounds.
2. **Associative-array lookup**: Storing factor-to-sound mappings in a hash map (`declare -A`) and looping through ordered keys.

## General Guidance

The key operation is the remainder (modulo) operator `%` inside an arithmetic context `(( ... ))`.
If a number is evenly divisible by a factor, `number % factor` evaluates to `0`.

To handle the fallback condition when none of the factors divide the number, Bash provides default parameter expansion: `${output:-${num}}`. This syntax evaluates to `${num}` if `${output}` is unset or empty, avoiding repetitive `if [[ -z ${output} ]]` checks.

## Approach: String Concatenation

```bash
num=${1}
output=""

(( num % 3 == 0 )) && output+="Pling"
(( num % 5 == 0 )) && output+="Plang"
(( num % 7 == 0 )) && output+="Plong"

echo "${output:-${num}}"
```

This approach tests each factor sequentially using arithmetic compound commands. When a condition evaluates to true, the respective raindrop sound is appended to `output` using the `+=` operator.

For more details, see the [string concatenation approach][approach-string-concatenation].

## Approach: Associative-Array Lookup

```bash
num=${1}
output=""
declare -A sounds=([3]="Pling" [5]="Plang" [7]="Plong")

for factor in 3 5 7; do
  (( num % factor == 0 )) && output+="${sounds[${factor}]}"
done

echo "${output:-${num}}"
```

This approach uses an associative array (`declare -A`) to decouple the rule data (the factor-to-sound mappings) from the algorithm logic. A `for` loop iterates through the factor keys in increasing order, checking divisibility and appending sounds.

For more details, see the [associative-array approach][approach-associative-array].

## Which approach to use?

- **String concatenation** is the fastest and most concise method for this exercise. Because the problem only checks three fixed prime factors (3, 5, and 7), unrolling the conditions incurs zero array allocation or loop iteration overhead. It is also compatible with older Bash versions.
- **Associative-array lookup** is preferable when building extensible or data-driven code. If the problem were extended to dozens of factor-sound pairs, an associative array keeps the code DRY (Don't Repeat Yourself). Note that Bash associative arrays do not preserve insertion order, so keys must be explicitly iterated in the desired sequence (`for factor in 3 5 7`). Additionally, associative arrays require Bash 4.0+.

[approach-string-concatenation]: https://exercism.org/tracks/bash/exercises/raindrops/approaches/string-concatenation
[approach-associative-array]: https://exercism.org/tracks/bash/exercises/raindrops/approaches/associative-array
