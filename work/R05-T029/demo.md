# R05-T029 — ShellCheck Integration in Validator Demo

## Before Changes
Executing `bin/validate_one_exercise exercises/practice/darts` on the unpatched script only executed Bats tests without inspecting code quality:

```text
Processing darts
1..17
ok 1 Missed target
ok 2 On the outer circle
ok 3 On the middle circle
ok 4 On the inner circle
ok 5 Exactly on center
ok 6 Near the center
ok 7 Just within the inner circle
ok 8 Just outside the inner circle
ok 9 Just within the middle circle
ok 10 Just outside the middle circle
ok 11 Just within the outer circle
ok 12 Just outside the outer circle
ok 13 Asymmetric position between the inner and middle circles
ok 14 invalid args: no args
ok 15 invalid args: only 1 arg
ok 16 invalid args: first arg non-numeric
ok 17 invalid args: second arg non-numeric
Updated 1 path from the index
```

---

## After Changes (ShellCheck Installed)
When `shellcheck` is present, `bin/validate_one_exercise` automatically analyzes `.meta/example.sh`:

```text
Processing darts
Running ShellCheck on .meta/example.sh

In .meta/example.sh line 7:
    isnumeric "$1" && isnumeric "$2" || die "arguments must be numeric"
                   ^-- SC2015 (info): Note that A && B || C is not if-then-else. C may run when A is true.

For more information:
  https://www.shellcheck.net/wiki/SC2015 -- Note that A && B || C is not if-t...
Warning: ShellCheck reported issues in .meta/example.sh
1..17
ok 1 Missed target
ok 2 On the outer circle
ok 3 On the middle circle
ok 4 On the inner circle
ok 5 Exactly on center
ok 6 Near the center
ok 7 Just within the inner circle
ok 8 Just outside the inner circle
ok 9 Just within the middle circle
ok 10 Just outside the middle circle
ok 11 Just within the outer circle
ok 12 Just outside the outer circle
ok 13 Asymmetric position between the inner and middle circles
ok 14 invalid args: no args
ok 15 invalid args: only 1 arg
ok 16 invalid args: first arg non-numeric
ok 17 invalid args: second arg non-numeric
Updated 1 path from the index
```

---

## After Changes (ShellCheck Not Installed)
When `shellcheck` is not in `$PATH`, validation gracefully prints a skip message:

```text
Processing darts
ShellCheck is not installed, skipping ShellCheck validation
1..17
...
```
