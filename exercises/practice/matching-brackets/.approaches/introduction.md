# Introduction

There are several ways to determine if brackets and braces are properly matched and nested in Bash.
Two common and idiomatic approaches are using an array as a stack or using repeated pair removal with parameter expansion.

## Approach: Array stack

Using a stack is the classic computer science approach for bracket matching.
In Bash, an indexed array can serve as a last-in, first-out (LIFO) stack.

```bash
declare -a s=(); declare -A p=([')']='(' [']']='[' ['}']='{')
for ((i=0; i<${#1}; i++)); do c="${1:i:1}"
  [[ $c == ['([{'] ]] && s+=("$c")
  [[ $c == [')]}'] ]] && { ((!${#s[@]})) || [[ ${s[-1]} != ${p[$c]} ]] && { echo false; exit 0; }; unset 's[-1]'; }
done
((!${#s[@]})) && echo true || echo false
```

For more details, see the [Array stack approach][approach-array-stack].

## Approach: Repeated pair removal

Another technique is to filter the string to only bracket characters and repeatedly remove adjacent matching pairs (`()`, `[]`, `{}`) using parameter expansion until none remain.

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

For more details, see the [Repeated pair removal approach][approach-repeated-pair-removal].

## Which approach to use?

- **Array stack** runs in linear time $O(n)$ where $n$ is the length of the input string, since each character is examined once and pushed/popped at most once. It is the preferred algorithm for general nesting validation and large inputs.
- **Repeated pair removal** takes $O(n^2)$ time in the worst case (such as deeply nested brackets `((((...))))`), but is very concise and demonstrates Bash parameter expansion pattern substitution (`${var//pattern/}`). For typical short inputs in this exercise, both execute in milliseconds.

[approach-array-stack]: /tracks/bash/exercises/matching-brackets/approaches/array-stack
[approach-repeated-pair-removal]: /tracks/bash/exercises/matching-brackets/approaches/repeated-pair-removal
