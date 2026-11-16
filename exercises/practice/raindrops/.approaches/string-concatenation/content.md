# String Concatenation

```bash
#!/usr/bin/env bash

num=${1}
output=""

(( num % 3 == 0 )) && output+="Pling"
(( num % 5 == 0 )) && output+="Plang"
(( num % 7 == 0 )) && output+="Plong"

echo "${output:-${num}}"
```

The string concatenation approach tests each factor sequentially, appending each sound to an accumulator string if the divisibility condition is met.

## Divisibility with Arithmetic Evaluation

In Bash, the `(( ... ))` arithmetic compound command evaluates arithmetic expressions.
The modulo operator `%` computes the remainder of integer division:

```bash
(( num % 3 == 0 ))
```

When `num` is divisible by 3, the expression `num % 3 == 0` evaluates to 1 (true in arithmetic context), which returns shell exit status `0` ("success").
Inside arithmetic commands:
- Variables do not require the `$` prefix (e.g., `num` instead of `${num}`).
- Operators follow standard C-style precedence.

## Short-Circuit Evaluation vs. `if` Statements

We can append the sound using the `&&` short-circuit operator:

```bash
(( num % 3 == 0 )) && output+="Pling"
```

If the condition on the left evaluates to `0` (success/true), Bash executes the assignment on the right.
Alternatively, an explicit `if` statement can be used if you prefer more traditional control flow:

```bash
if (( num % 3 == 0 )); then
  output+="Pling"
fi
```

Both styles are common and idiomatic in Bash. The short-circuit idiom is concise and reads cleanly for sequential guards.

## Appending with `+=`

Bash 3.1 introduced the `+=` operator for string and array appending.
Writing:

```bash
output+="Pling"
```

is cleaner and more idiomatic than older expansion patterns such as:

```bash
output="${output}Pling"
```

## Default Value Parameter Expansion

If none of the factors (3, 5, or 7) divide `num`, `output` remains an empty string `""`.
Instead of writing an explicit test:

```bash
if [[ -z "${output}" ]]; then
  echo "${num}"
else
  echo "${output}"
fi
```

Bash allows you to provide a default fallback value using parameter expansion:

```bash
echo "${output:-${num}}"
```

The `${parameter:-word}` construct tests whether `output` is unset or empty (null). If it is unset or empty, Bash expands `${num}`; otherwise, it expands `${output}`.

## Structuring with Functions

In larger scripts or production environments complying with style guides (such as the Google Shell Style Guide), wrapping the logic in a `main()` function with local variables is standard practice:

```bash
main() {
  local -i num="${1}"
  local output=""

  (( num % 3 == 0 )) && output+="Pling"
  (( num % 5 == 0 )) && output+="Plang"
  (( num % 7 == 0 )) && output+="Plong"

  echo "${output:-${num}}"
}

main "${@}"
```

## Trade-offs

- **Performance:** This is the most efficient solution in Bash. It uses purely shell built-ins with no subshells (`$(...)`), no process forks, and no data structure initialization overhead.
- **Simplicity:** Extremely easy to read, debug, and maintain for a small, static set of requirements.
- **Scalability:** If the number of rules grows significantly, duplicating the conditional lines can become verbose and repetitive compared to a table-driven loop.
