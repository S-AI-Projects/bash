# Introduction

There are multiple idiomatic ways to calculate Scrabble scores in Bash.
The two most common approaches use either an **associative array** lookup or pattern matching with a **case statement**.

## General guidance

- Normalize input case early: `${1^^}` converts the input word to uppercase in Bash 4+.
- Iterate over each character: using string slicing `${word:i:1}` is clean, fast, and does not fork external processes like `grep` or `fold`.
- Accumulate the score with Bash arithmetic expansion `(( score += ... ))`.

## Approach: Associative array lookup

```bash
word=${1^^}
score=0
declare -A scores=(
    [A]=1 [E]=1 [I]=1 [O]=1 [U]=1 [L]=1 [N]=1 [R]=1 [S]=1 [T]=1
    [D]=2 [G]=2
    [B]=3 [C]=3 [M]=3 [P]=3
    [F]=4 [H]=4 [V]=4 [W]=4 [Y]=4
    [K]=5
    [J]=8 [X]=8
    [Q]=10 [Z]=10
)
for (( i = 0; i < ${#word}; i++ )); do
    letter=${word:i:1}
    (( score += scores[$letter] ))
done
echo "$score"
```

For more details, see the [Associative Array approach][approach-associative-array].

## Approach: Case statement with letter groups

```bash
word=${1^^}
score=0
for (( i = 0; i < ${#word}; i++ )); do
    letter=${word:i:1}
    case "$letter" in
        [AEIOULNRST]) (( score += 1 )) ;;
        [DG])         (( score += 2 )) ;;
        [BCMP])       (( score += 3 )) ;;
        [FHVWY])      (( score += 4 )) ;;
        [K])          (( score += 5 )) ;;
        [JX])         (( score += 8 )) ;;
        [QZ])         (( score += 10 )) ;;
    esac
done
echo "$score"
```

For more details, see the [Case statement with letter groups approach][approach-case-groups].

## Which approach to use?

- **Associative array** offers $O(1)$ constant time lookup per letter and keeps the letter-to-score mapping explicit and data-driven.
- **Case statement** groups letters having identical point values into bracket character sets (`[AEIOULNRST]`), avoiding array allocation entirely and executing purely within shell built-in pattern matching.

[approach-associative-array]: https://exercism.org/tracks/bash/exercises/scrabble-score/approaches/associative-array
[approach-case-groups]: https://exercism.org/tracks/bash/exercises/scrabble-score/approaches/case-with-letter-groups
