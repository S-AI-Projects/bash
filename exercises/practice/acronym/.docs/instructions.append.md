# Dummy header

## Bash-specific instructions

### 1. Beware of filename expansion (globbing)

When expanding an unquoted variable containing whitespace to iterate over
words, Bash performs word splitting followed by pathname expansion (globbing).
If the input phrase contains characters such as `*` or `?` (for example,
`"Two * Words"`), Bash attempts to match and expand those characters against
filenames in the current directory:

```bash
phrase="Two * Words"
for word in $phrase; do
  echo "$word"  # '*' expands to all files in the directory!
done
```

See [Shell Expansions][shell-expansions] in the Bash manual.

### 2. Disabling globbing with `set -f`

You can disable pathname expansion using the `set -f` (or `set -o noglob`) shell
option before performing word splitting:

```bash
set -f
for word in $phrase; do
  echo "$word"  # '*' remains a literal character
done
set +f
```

See [The Set Builtin][the-set-builtin] in the Bash manual.

### 3. Word boundaries and hyphens

The exercise treats hyphens (`-`) as word separators like whitespace.
You can replace hyphens with spaces using pattern replacement parameter
expansion before splitting into words:

```bash
clean_phrase="${phrase//-/ }"
```

See [Shell Parameter Expansion][shell-parameter-expansion] in the Bash manual.

### 4. Case conversion

Bash 4+ provides parameter expansion operators to change string casing
without calling external utilities like `tr`.
For example, `${word^^}` converts the string to uppercase, and `${word:0:1}`
extracts the first character.

[shell-expansions]: https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions
[the-set-builtin]: https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
[shell-parameter-expansion]: https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
