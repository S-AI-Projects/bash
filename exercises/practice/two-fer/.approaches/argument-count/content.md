# Argument count

```bash
if (( $# > 0 )); then
    name=$1
else
    name=you
fi
echo "One for ${name}, one for me."
```

An explicit way to determine whether a name was supplied is to check the number of positional parameters passed to the script using the special variable `$#`.

## How it works

- `$#` expands to the number of positional parameters passed to the script.
- If at least one argument was passed (`(( $# > 0 ))`), we assign `name=$1`.
- Otherwise, no argument was given, so we assign the fallback `name=you`.
- Finally, we print the formatted string with `echo "One for ${name}, one for me."`.

## Arithmetic evaluation `(( ... ))` vs test `[ ... ]`

Because `$#` is guaranteed to be a number, using the Bash arithmetic construct `(( ... ))` is preferred over the external or test command `[`:

- `(( $# > 0 ))` evaluates directly as numeric integer comparison in native shell arithmetic.
- Alternatively, checking for zero arguments `(( $# == 0 ))` or `(( $# < 1 ))` works equally well.
- In POSIX `sh` without arithmetic evaluation, one would write `[ "$#" -gt 0 ]` or `[ "$#" -eq 0 ]`, which requires quoting the variable expansion to prevent syntax errors if `$#` were ever empty.

## Quoting and Variable Assignment

In variable assignment `name=$1`, word splitting is not performed on the right-hand side of a scalar assignment in Bash. However, when referencing `${name}` inside `echo`, wrapping the string in double quotes (`"One for ${name}, one for me."`) prevents pathname expansion (globbing) when the name contains characters like `*` or `?`.

[conditional-constructs]: https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs
