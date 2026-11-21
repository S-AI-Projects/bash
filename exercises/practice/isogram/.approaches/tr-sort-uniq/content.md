# tr, sort and uniq

```bash
repeated=$(
    tr -cd '[:alpha:]' <<< "${1,,}" |
    fold -w1 |
    sort |
    uniq -d
)
[[ -z $repeated ]] && echo true || echo false
```

Calling external tools is a natural way to solve problems in Bash: connect small, specialized tools with a pipeline and look at what comes out.
Here the pipeline prints every letter that appears more than once, so an empty result means the phrase is an isogram.

The pipeline has four stages:

1. `tr -cd '[:alpha:]' <<< "${1,,}"` first lowercases the phrase with `${1,,}`, and then `tr` deletes (`-d`) every character that is _not_ (`-c`, the complement) a letter.
   What is left is the letters only, with no spaces, hyphens or even the newline that the here-string adds.
2. `fold -w1` wraps its input at one character per line, so each letter ends up on a line of its own.
3. `sort` puts equal lines next to each other.
4. `uniq -d` prints one copy of each line that is repeated.

`uniq` only compares neighbouring lines, so the `sort` is not optional.
Without it, the two `a`s in `alpha` would be separated by other letters and `uniq -d` would not see them.

| phrase         | after `tr`   | after `sort` (one letter per line) | `uniq -d` prints | result  |
| -------------- | ------------ | ---------------------------------- | ---------------- | ------- |
| `isogram`      | `isogram`    | `a g i m o r s`                    | nothing          | `true`  |
| `Alphabet`     | `alphabet`   | `a a b e h l p t`                  | `a`              | `false` |
| `six-year-old` | `sixyearold` | `a d e i l o r s x y`              | nothing          | `true`  |
| `up-to-date`   | `uptodate`   | `a d e o p t t u`                  | `t`              | `false` |

The `$( ... )` command substitution captures the output of the pipeline in the variable `repeated`.
The last line tests whether it is empty with `[[ -z $repeated ]]`:
if it is, no letter is repeated and the program prints `true`; otherwise it prints `false`.
An empty phrase gives an empty pipeline, so it is an isogram.

Each stage is its own process.
Starting a process takes more work than running a Bash builtin: the shell has to copy its environment, start the child, connect the input and output, and wait for it to finish.
This pipeline starts four of them, plus the subshell for the command substitution, so it is slower than doing the same work with a loop in Bash.
For a short phrase you will not notice, but be careful about calling a pipeline like this from inside a loop, where the cost adds up.

~~~~exercism/note
`fold -w1` is one way to put each letter on its own line.
Another is `grep -o .`, which prints each match of `.` (any single character) on its own line.

```bash
tr -cd '[:alpha:]' <<< "${1,,}" | grep -o . | sort | uniq -d
```
~~~~
