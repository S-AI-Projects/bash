# Associative Array Approach

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

## How it works

1. **Case conversion**: `${1^^}` transforms the input word to all-uppercase, so lookups remain case-insensitive.
2. **Associative array**: `declare -A scores=(...)` defines key-value pairs mapping each letter to its point value.
3. **Looping without subprocesses**: The C-style `for (( i = 0; i < ${#word}; i++ ))` iterates over string indices. `${word:i:1}` extracts one character at a time.
4. **Arithmetic addition**: `(( score += scores[$letter] ))` looks up the value in $O(1)$ and adds it directly to `score`.
