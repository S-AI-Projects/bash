# Instructions append

## Integer limits in Bash

Bash does its integer arithmetic with [arithmetic expansion][expansion], and
those integers have a fixed size.
The hints below are about what happens when the numbers get big.
Each one has a small example, so you can run the lines yourself and see.

### Powers of two

Inside `$(( ))`, the `**` operator raises a number to a power:

```bash
echo $(( 2 ** 3 ))    # => 8
echo $(( 2 ** 0 ))    # => 1
```

Square 1 holds one grain, square 2 holds two, square 3 holds four, and so on.
Square `n` holds 2 to the power of `n - 1`.
See [Shell Arithmetic][arithmetic] for the list of operators.

### Bash integers have a size limit

Bash does arithmetic with _signed_ integers, which are 64 bits wide on most
systems.
One bit is used for the sign, so the largest value that fits is 2^63 - 1:

```bash
echo $(( 2 ** 62 ))              # => 4611686018427387904
echo $(( 9223372036854775807 ))  # => 9223372036854775807
```

Compare that largest value with the number of grains the tests expect on
square 64.
The [arithmetic expansion][expansion] section describes how the expressions are
evaluated.

### Overflow does not raise an error

When a result is too big, Bash does not stop, print a warning or switch to a
bigger type.
The number silently wraps around:

```bash
echo $(( 2 ** 63 ))                  # => -9223372036854775808
echo $(( 9223372036854775807 + 1 ))  # => -9223372036854775808
echo $(( 2 ** 64 ))                  # => 0
```

The same happens to a running total.
The tests expect the true values for square 64 and for the total of the whole
board, so a result that looks wrong is not always a wrong calculation, and you
will need a way around this limit.
The [Shell Arithmetic][arithmetic] section is a good place to start looking.

### Shifting instead of multiplying

Doubling a number is the same as moving its bits one place to the left, and
Bash has the `<<` operator for that:

```bash
echo $(( 1 << 3 ))     # => 8
echo $(( 1 << 62 ))    # => 4611686018427387904
echo $(( 1 << 63 ))    # => -9223372036854775808
```

Shifting is subject to the same 64 bit limit as `**`.
Both operators are listed in the [Shell Arithmetic][arithmetic] section.

### Words in arithmetic expressions

In arithmetic, a word that is not a number is treated as the name of a
variable, and a variable that is not set counts as `0`.
That includes the operands of `-lt` and `-gt` inside `[[ ]]`:

```bash
unset total
[[ total -lt 1 ]] && echo "total is less than 1"
# => total is less than 1
```

So if the argument can be either a number or the word `total`, decide which one
you were given before you compare it with numbers.
See [Shell Arithmetic][arithmetic] for how names are evaluated.

[expansion]: https://www.gnu.org/software/bash/manual/bash.html\#Arithmetic-Expansion
[arithmetic]: https://www.gnu.org/software/bash/manual/bash.html\#Shell-Arithmetic
