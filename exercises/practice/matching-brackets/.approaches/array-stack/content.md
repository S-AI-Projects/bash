# Array stack

```bash
declare -a s=(); declare -A p=([')']='(' [']']='[' ['}']='{')
for ((i=0; i<${#1}; i++)); do c="${1:i:1}"
  [[ $c == ['([{'] ]] && s+=("$c")
  [[ $c == [')]}'] ]] && { ((!${#s[@]})) || [[ ${s[-1]} != ${p[$c]} ]] && { echo false; exit 0; }; unset 's[-1]'; }
done
((!${#s[@]})) && echo true || echo false
```

## How it works

1. **Stack setup**: An indexed array `s=()` acts as our last-in, first-out (LIFO) stack. An associative array `p` maps each closing bracket to its matching opening bracket.
2. **Iteration**: A `for` loop iterates through each character of the input string using `${1:i:1}`.
3. **Opening brackets**: When an opening bracket (`(`, `[`, `{`) is encountered, it is pushed onto the stack via `s+=("$c")`.
4. **Closing brackets**: When a closing bracket (`)`, `]`, `}`) is encountered:
   - Check if the stack is empty (`((!${#s[@]}))`) or the top element `${s[-1]}` does not match `${p[$c]}`. If either condition holds, the string is malformed; output `false` and exit.
   - If they match, pop the opening bracket from the stack using `unset 's[-1]'`.
5. **Non-bracket characters**: Any characters other than brackets are ignored.
6. **Final validation**: When iteration ends, output `true` if the stack is completely empty (`((!${#s[@]}))`), or `false` if unmatched opening brackets remain.

## Complexity

- **Time complexity:** $O(n)$, where $n$ is the length of the input string. Each character is processed once, with $O(1)$ push and pop operations.
- **Space complexity:** $O(n)$ in the worst case (e.g. all opening brackets), where the stack stores all brackets until the end.
