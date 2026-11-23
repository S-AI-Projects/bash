# Parameter expansion

```bash
echo "One for ${1-you}, one for me."
```

The most concise and idiomatic approach in Bash is to use [parameter expansion default values][param-expansion].

## How it works

The syntax `${parameter-word}` checks whether the parameter is set:
- If `$1` is set (meaning an argument was supplied to the script), its value is expanded.
- If `$1` is unset (no argument was supplied), the default word `"you"` is substituted instead.

```bash
echo "One for ${1-you}, one for me."
```

### Why `${1-you}` instead of `${1:-you}`?

Bash offers two similar parameter expansion forms for default values:

1. `${parameter-default}`: expands to `default` **only if** `parameter` is unset.
2. `${parameter:-default}`: expands to `default` if `parameter` is unset **or null** (an empty string `""`).

In this exercise, we want to know whether a positional argument was provided at all. If the caller explicitly provides an empty string argument (`./two_fer.sh ""`), `$1` is set (to `""`).
- With `${1-you}`, Bash honors the provided empty string, yielding `"One for , one for me."`.
- With `${1:-you}`, the colon causes Bash to treat an empty string as unset, replacing it with `"you"`.

Using `${1-you}` precisely tests for the presence of the argument without conflating an empty argument with a missing argument.

## Quoting

Enclosing the entire message in double quotes (`"One for ${1-you}, one for me."`) is essential in Bash. It ensures that names with spaces (e.g. `"John Smith"`) or glob characters (e.g. `"* "`) are preserved literally and not subjected to word splitting or filename pathname expansion.

[param-expansion]: https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
