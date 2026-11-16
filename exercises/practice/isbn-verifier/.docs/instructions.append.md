# Dummy header

## Bash-specific guidance

Here are several helpful tips and idiomatic Bash constructs to consider when
implementing this exercise:

### 1. Removing separating hyphens

Input ISBN strings may contain hyphens (e.g., `"3-598-21508-8"`). You can strip
them using Bash's pattern substitution
[parameter expansion][bash-parameter-expansion]:

```bash
isbn="3-598-21508-8"
clean="${isbn//-/}"
echo "$clean"
# Output: 3598215088
```

### 2. Format and length validation

A normalized ISBN-10 candidate must contain exactly 10 characters: 9 numeric
digits followed by a single check character (either a digit or `X`).

When validating the format with regular expressions using the `=~` operator
inside [conditional expressions][bash-conditional-constructs] (`[[ ... ]]`), be
sure to anchor your pattern to the beginning (`^`) and end (`$`) of the string:

```bash
if [[ $clean =~ ^[0-9]{9}[0-9X]$ ]]; then
  echo "Valid format"
fi
```

Without anchoring, an unanchored pattern matches substrings within longer
inputs (such as `"98245726788"`), causing inputs that are too long to
incorrectly pass validation. Alternatively, verify the string length explicitly
using `${#clean}` before checking characters.

### 3. Handling the 'X' check character

The check character `X` represents the numeric value `10` and is only valid at
the 10th position (index 9). You can extract individual characters using
[substring expansion][bash-parameter-expansion] `${variable:offset:length}`:

```bash
check_digit="${clean:9:1}"
if [[ $check_digit == "X" ]]; then
  value=10
else
  value=$check_digit
fi
```

### 4. Character iteration and arithmetic evaluation

To calculate the formula `(d₁*10 + d₂*9 + ... + d₁₀*1) mod 11 == 0`, you can
iterate over character indices with a C-style loop and accumulate weights using
[arithmetic evaluation][bash-arithmetic] `(( ... ))`:

```bash
sum=0
(( sum += digit * weight ))
if (( sum % 11 == 0 )); then
  echo "valid"
fi
```

[bash-parameter-expansion]: https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
[bash-conditional-constructs]: https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs
[bash-arithmetic]: https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic
