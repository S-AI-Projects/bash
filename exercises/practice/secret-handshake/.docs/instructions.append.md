# Dummy header

## Bash-specific guidance

### Bitwise operations in Bash

Bash supports bitwise operators inside [arithmetic evaluation][bash-arithmetic]
(`(( ... ))` and `$(( ... ))`). You can check if a specific bit is set using
the bitwise AND (`&`) operator:

```bash
# Check if the least significant bit (bit 0) is set
if (( number & 1 )); then
    echo "bit 0 is set"
fi

# Check a bit at position i using the left shift operator
if (( number & (1 << i) )); then
    echo "bit $i is set"
fi
```

### Reversing an array

When bit 4 (`16` or `10000` in binary) is set, the sequence of operations
must be reversed. In Bash, you can reverse an array by iterating backwards
from `${#items[@]} - 1` down to `0`:

```bash
reversed=()
for (( i = ${#items[@]} - 1; i >= 0; i-- )); do
    reversed+=( "${items[i]}" )
done
```

For more details on manipulating indexed arrays, refer to the
[Bash Arrays documentation][bash-arrays].

### Handling zero and empty sequences

When given `0`, none of the action bits are set.
Your script should produce an empty output without errors.
Checking `(( number == 0 ))` or letting loop conditions evaluate to an
empty result list naturally handles this case.

### Joining array elements with commas

The expected output format is a comma-separated list of actions without
extra spaces (for example, `wink,jump`).
A common Bash idiom to join array elements with a delimiter is setting `IFS`
when expanding `*`:

```bash
IFS=,
echo "${actions[*]}"
```

Setting `IFS` locally within a function or command avoids side effects on
the rest of your script. See [Special Parameters][bash-special-parameters]
for details on how `IFS` affects `${array[*]}`.

[bash-arithmetic]: https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic
[bash-arrays]: https://www.gnu.org/software/bash/manual/bash.html#Arrays
[bash-special-parameters]: https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters
