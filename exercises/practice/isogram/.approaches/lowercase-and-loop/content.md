# Lowercase and loop

```bash
phrase=${1,,}
for (( i = 0; i < ${#phrase}; i++ )); do
    char=${phrase:i:1}
    [[ $char == [[:lower:]] ]] || continue
    [[ $seen == *"$char"* ]] && { echo false; exit; }
    seen+=$char
done
echo true
```

This approach lowercases the phrase once, and then walks through it one character at a time, keeping a string of the letters it has already seen.

The first line, `phrase=${1,,}`, uses the `,,` [case modification][case-modification] parameter expansion to lowercase the first argument.
After that, `A` and `a` are the same character, so `Alphabet` has two `a`s.

The `for` loop is the arithmetic form of the `for` command.
`${#phrase}` is the length of the phrase, and `${phrase:i:1}` is the one character at position `i`.
Inside the `[[ ... ]]` and `(( ... ))` constructs and in the offset of a substring, a variable can be used without the dollar sign.

For each character:

1. `[[ $char == [[:lower:]] ]] || continue` skips anything that is not a lowercase letter.
   The right-hand side of `==` inside `[[ ... ]]` is a pattern, and `[[:lower:]]` matches one lowercase letter.
   This is how spaces and hyphens are ignored.
2. `[[ $seen == *"$char"* ]]` asks if the letter already appears anywhere in `seen`.
   The `*` on both sides matches anything, and the quotes make the letter match literally.
   If it does, the phrase has a repeated letter, so the program prints `false` and exits right away.
3. Otherwise, `seen+=$char` appends the letter to `seen`, and the loop moves on to the next character.

If the loop finishes without finding a repeated letter, the program prints `true`.
An empty phrase never enters the loop body, so it is an isogram.

| phrase         | letters seen when the loop stops | result  |
| -------------- | -------------------------------- | ------- |
| `isogram`      | all of `isogram`                 | `true`  |
| `Alphabet`     | `alph`, then the second `a`      | `false` |
| `six-year-old` | `sixyearold` (hyphens skipped)   | `true`  |
| `up-to-date`   | `uptoda`, then the second `t`    | `false` |

Because the program exits at the first repeated letter, it does not look at the rest of the phrase when the answer is already known.
It also only uses Bash builtins, so it does not need to start any other process.

~~~~exercism/note
`seen` is never assigned before the loop.
In Bash, a variable that has not been set expands to an empty string, so the first test `[[ $seen == *"$char"* ]]` simply fails and the first letter is appended.

If you prefer to be explicit, you could write `seen=""` before the loop.
~~~~

[case-modification]: https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
