# Case statement

```bash
year=$1
case "$(( year % 4 )),$(( year % 100 )),$(( year % 400 ))" in
    0,0,0) echo true ;;
    0,0,*) echo false ;;
    0,*)   echo true ;;
    *)     echo false ;;
esac
```

This approach turns the three divisibility checks into a single string and matches it against patterns.

The [arithmetic expansion][arithmetic-expansion] `$(( year % 4 ))` is replaced by the remainder of dividing `year` by 4.
The three remainders, for 4, 100 and 400, are joined with commas to build one word such as `0,20,20`.
A remainder of `0` means the year is evenly divisible by that number.

The [`case` command][case-command] compares the word with each pattern in turn and runs the commands for the first pattern that matches.
That makes the order of the patterns part of the rule:

| pattern  | meaning                                          | result |
| -------- | ------------------------------------------------ | ------ |
| `0,0,0`  | divisible by 4, 100 and 400                      |   true |
| `0,0,*`  | divisible by 4 and 100, but not by 400           |  false |
| `0,*`    | divisible by 4, but not by 100                   |   true |
| `*`      | everything else: not divisible by 4              |  false |

| year | remainders (4, 100, 400) | first matching pattern | result |
| ---- | ------------------------ | ---------------------- | ------ |
| 2020 | `0,20,20`                | `0,*`                  |   true |
| 2019 | `3,19,19`                | `*`                    |  false |
| 2000 | `0,0,0`                  | `0,0,0`                |   true |
| 1900 | `0,0,300`                | `0,0,*`                |  false |

The `*` in a pattern matches any string, so `0,0,*` means "the first two remainders are `0`, whatever the third one is".
If `0,*` were listed before `0,0,*`, the year 1900 would match it and be reported as a leap year, so the more specific patterns must come first.

Unlike the [Boolean chain approach][approach-boolean-chain], this approach always calculates all three remainders, because the word has to be built before it can be matched.
For a language like Bash, where each operation is relatively slow anyway, the difference is small.
The benefit is that the rules are listed as a table that reads from top to bottom.

~~~~exercism/note
Inside `case`, the double quotes around the word are not required, because the word is not split into separate arguments.
They are used here so that the comma-separated word is easy to see as a single string.

Patterns in `case` use shell _globbing_, not regular expressions.
Each pattern ends with `)` and each list of commands ends with `;;`.

See [the Conditional Constructs section][conditional-constructs] in the Bash manual.
~~~~

[arithmetic-expansion]: https://www.gnu.org/software/bash/manual/bash.html\#Arithmetic-Expansion
[case-command]: https://www.gnu.org/software/bash/manual/bash.html\#Conditional-Constructs
[conditional-constructs]: https://www.gnu.org/software/bash/manual/bash.html\#Conditional-Constructs
[approach-boolean-chain]: https://exercism.org/tracks/bash/exercises/leap/approaches/boolean-chain
