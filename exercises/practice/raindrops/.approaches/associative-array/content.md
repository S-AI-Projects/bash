# Associative-Array Lookup

```bash
#!/usr/bin/env bash

num=${1}
output=""
declare -A sounds=([3]="Pling" [5]="Plang" [7]="Plong")

for factor in 3 5 7; do
  (( num % factor == 0 )) && output+="${sounds[${factor}]}"
done

echo "${output:-${num}}"
```

The associative-array approach decouples the rules (factors and their matching raindrop sounds) from the evaluation logic. It stores the mappings in a hash table and loops through the factors.

## Declaring Associative Arrays

Associative arrays (hash maps with arbitrary string keys) were introduced in **Bash 4.0**.
Unlike indexed arrays, an associative array must be declared with the `-A` attribute:

```bash
declare -A sounds=(
  [3]="Pling"
  [5]="Plang"
  [7]="Plong"
)
```

Within a function, using `local -A` scopes the array strictly to the execution of that function, preventing pollution of the global shell environment.

## Key Ordering in Bash Associative Arrays

A critical caveat with Bash associative arrays is that **they are implemented as hash tables and do not preserve insertion order**.

If you iterate through the keys using `"${!sounds[@]}"`:

```bash
# Caution: Order is not guaranteed!
for factor in "${!sounds[@]}"; do
  ...
done
```

The iteration order depends on hash collisions and internal bucket indexing. It could yield `7 3 5` or `5 7 3`, which would produce incorrect sound strings like `"PlongPlingPlang"` instead of `"PlingPlangPlong"`.

To guarantee the required factor sequence (3 before 5, and 5 before 7), iterate over an explicit, ordered sequence of keys:

```bash
for factor in 3 5 7; do
  (( num % factor == 0 )) && output+="${sounds[${factor}]}"
done
```

## Default Value Parameter Expansion

After checking all factors, the accumulator `${output}` contains the combined raindrop sounds or remains empty if no factors matched.
Using the `${output:-${num}}` parameter expansion cleanly outputs `${num}` when `${output}` is empty, eliminating the need for an extra `if/else` check.

## Structuring with Functions

In larger scripts or production environments complying with style guides (such as the Google Shell Style Guide), wrapping the logic in a `main()` function with local variables is standard practice:

```bash
main() {
  local -i num="${1}"
  local output=""
  local -i factor

  local -A sounds=(
    [3]="Pling"
    [5]="Plang"
    [7]="Plong"
  )

  for factor in 3 5 7; do
    if (( num % factor == 0 )); then
      output+="${sounds[${factor}]}"
    fi
  done

  echo "${output:-${num}}"
}

main "${@}"
```

## Trade-offs

- **Extensibility & Separation of Concerns:** Storing rules as data makes it easy to add or modify rules without altering the control loop. If new factors (such as 11 or 13) are introduced, only the array definition and key list need updates.
- **Overhead:** Creating and populating an associative array, iterating with a loop, and executing hash table lookups adds slight interpreter overhead compared to unrolled arithmetic evaluations. However, for a single script invocation, this overhead is minimal.
- **Compatibility:** Requires Bash 4.0 or newer. Systems shipping with legacy Bash 3.2 (such as the default macOS `/bin/bash`) cannot run scripts utilizing `declare -A` or `local -A` without installing a modern Bash via Homebrew or MacPorts.
