# Repeated pair removal

```bash
b=""
for ((i=0; i<${#1}; i++)); do c="${1:i:1}"
  case $c in ']'|'['|'('|')'|'{'|'}') b+=$c ;; esac
done
while [[ $b == *'()'* || $b == *'[]'* || $b == *'{}'* ]]; do
  b=${b//\(\)/}; b=${b//\[\]/}; b=${b//\{\}/}
done
[[ -z $b ]] && echo true || echo false
```

## How it works

1. **Filter bracket characters**: A loop extracts each character and appends only bracket characters (`[`, `]`, `(`, `)`, `{`, `}`) to variable `b`, stripping irrelevant characters like letters, digits, and whitespace.
2. **Loop adjacent pairs**: A `while` loop checks whether `b` contains any adjacent matching pair: `()`, `[]`, or `{}`.
3. **Parameter expansion**: Bash pattern replacement `${b//pattern/}` deletes all occurrences of adjacent matching pairs from the string.
4. **Termination**: When no more adjacent matching pairs can be reduced, the loop finishes.
5. **Validation**: If all brackets matched and were eliminated, `b` will be empty (`-z $b`), outputting `true`. If mismatched or orphaned brackets remain (e.g. `(]` or `}{`), `b` will not be empty, outputting `false`.

## Complexity

- **Time complexity:** $O(n^2)$ in the worst case (for example, deeply nested pairs `((((...))))` where each pass removes one innermost pair and constructs a new string of length $O(n)$).
- **Space complexity:** $O(n)$ to store the filtered bracket string and intermediate replacements.
