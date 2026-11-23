# Dummy header

## Bash-specific instructions

### Associative Arrays for Counting

Bash (version 4.0+) supports associative arrays, which use strings as keys instead of numeric indices. They are declared using `declare -A` (or `local -A` inside functions).

You can initialize and increment values like this:

```bash
declare -A counts=([A]=0 [C]=0 [G]=0 [T]=0)
counts[A]=$(( counts[A] + 1 ))
echo "A: ${counts[A]}"
```

### Validating Strand Characters

A valid DNA strand consists only of the letters `A`, `C`, `G`, and `T`. If any other character appears in the input, your script must output an error message and exit with a non-zero exit status:

```text
Invalid nucleotide in strand
```

To test whether a string contains characters other than valid nucleotides, you can use pattern matching or regular expressions within `[[ ... ]]`:

```bash
# Pattern matching: checks if the string contains any character other than A, C, G, or T
if [[ $strand == *[^ACGT]* ]]; then
    echo "Invalid nucleotide in strand" >&2
    exit 1
fi
```

Alternatively, you can test with regular expressions using the `=~` operator:

```bash
if [[ $strand =~ [^ACGT] ]]; then
    echo "Invalid nucleotide in strand" >&2
    exit 1
fi
```
