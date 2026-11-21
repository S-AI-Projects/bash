# Dummy header

## Bash-specific hints

There is more than one way to swap characters in Bash.
The hints below point at the tools; putting them together is up to you.

### Replacing with parameter expansion

`${var//pattern/replacement}` replaces _every_ match of `pattern` in `var`.
With a single slash, `${var/pattern/replacement}` replaces only the first one.
This is a [parameter expansion][parameter-expansion], so Bash does the work
itself and no other process is started.

```bash
word=banana
echo "${word//a/o}"    # => bonono
echo "${word/a/o}"     # => bonana
```

Be careful when you replace more than one letter this way.
Each replacement works on the result of the previous one,
so a later replacement can undo an earlier one.

```bash
pair=xy
pair=${pair//x/y}      # pair is now yy
pair=${pair//y/x}      # pair is now xx, not yx
echo "$pair"           # => xx
```

### Replacing with tr

The `tr` command (see `man tr`) translates characters in a single pass:
the first character of the first set becomes the first character of the second
set, the second becomes the second, and so on.
Because it looks at each input character only once, one translation cannot undo
another.
It reads standard input, so a here-string (`<<<`) is a handy way to feed it.

```bash
tr 'el' 'ip' <<< "hello"    # => hippo
```

Either tool can solve this exercise.
Parameter expansion stays inside Bash, while `tr` is an external program
that does the whole job in one step.

### Rejecting invalid characters

In a glob pattern, `[!abc]` matches any single character that is _not_ `a`,
`b` or `c`.
Inside [`[[ ... ]]`][conditional], `*[!abc]*` therefore matches any string that
contains at least one such character.
See [pattern matching][pattern-matching] in the Bash manual.

```bash
for s in abcabc abcxabc; do
    if [[ $s == *[!abc]* ]]; then echo "$s: bad"; else echo "$s: ok"; fi
done
# => abcabc: ok
# => abcxabc: bad
```

### Print nothing but the error

The tests compare the _whole_ output with `assert_output`.
For input such as `ACGTXCTTAA`, the output must be exactly
`Invalid nucleotide detected.`, not some translated letters followed by
that message.
So find out whether the strand is valid _before_ you print any of the result,
or collect the result in a variable and print it only at the end.

The tests also expect the script to fail, so finish with a non-zero exit status.
A script's exit status is available as `$?` right after it runs.

```bash
bash -c 'echo "oops"; exit 3'; echo "status: $?"
# => oops
# => status: 3
```

[parameter-expansion]: https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
[pattern-matching]: https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching
[conditional]: https://www.gnu.org/software/bash/manual/bash.html#index-_005b_005b
