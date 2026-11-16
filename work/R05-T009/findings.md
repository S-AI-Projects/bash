# R05-T009: validate_one_exercise keeps uncommitted work

## Goal
`bin/validate_one_exercise` overwrites the student stub with the example
solution and restored it with `git checkout` in its EXIT trap. That also
discards uncommitted work in the stub. Back the stub up to a temp file and
restore it from there.

## What each script does
- `bin/validate_one_exercise <dir>`: checks the exercise config and the number of
  commented skip lines, copies the example over the stub, runs the tests with
  `BATS_RUN_SKIPPED=true`, and restores the stub on exit.
- `bin/validate_exercises`: runs `validate_one_exercise` for every exercise under
  `exercises/*/*` and stops at the first failure (`errexit`).
- `bin/generate_tests`: renders `.meta/template.j2` and `tests.toml` into the
  exercise's `.bats` file.
- `.github/scripts/ci`: runs `bin/validate_exercises`.
- `.github/scripts/pr`: runs `validate_one_exercise` for the exercises a pull
  request touches.

## Change
In `bin/validate_one_exercise`:
- `backup=$(mktemp "${TMPDIR:-/tmp}/validate_one_exercise.XXXXXX")` and
  `cp "${stub}" "${backup}"` before the stub is overwritten.
- The EXIT trap's `cleanup` does `cp "${backup}" "${stub}"` and `rm -f "${backup}"`
  instead of `git checkout "${stub}"`.
- The backup is complete before the trap is set, so the trap never restores an
  empty file over the stub.
- `# shellcheck disable=SC2016` (with a reason) on the skip-line regex, which has
  a literal `$` inside single quotes; without it the task's `shellcheck` check
  fails on an existing finding.
- As a side effect the script no longer needs git.

## Demo: uncommitted edit to exercises/practice/hello-world/hello_world.sh
The demo appends `echo "my uncommitted work"` to the stub, runs the validator,
and shows `git diff` before and after (`demo.sh`).

Original script (`demo_before.txt`):
    --- git diff BEFORE running the validator
    diff --git a/exercises/practice/hello-world/hello_world.sh b/exercises/practice/hello-world/hello_world.sh
    index 5f126f0..52013e7 100644
    --- a/exercises/practice/hello-world/hello_world.sh
    +++ b/exercises/practice/hello-world/hello_world.sh
    @@ -1,3 +1,4 @@
     #!/usr/bin/env bash
     
     echo "Goodbye, Mars!"
    +echo "my uncommitted work"
    --- running the validator
    Processing hello-world
    1..1
    ok 1 test_say_hi
    Updated 1 path from the index
    --- git diff AFTER running the validator
    --- files left in the temp directory:        0

New script (`demo_after.txt`):
    --- git diff BEFORE running the validator
    diff --git a/exercises/practice/hello-world/hello_world.sh b/exercises/practice/hello-world/hello_world.sh
    index 5f126f0..52013e7 100644
    --- a/exercises/practice/hello-world/hello_world.sh
    +++ b/exercises/practice/hello-world/hello_world.sh
    @@ -1,3 +1,4 @@
     #!/usr/bin/env bash
     
     echo "Goodbye, Mars!"
    +echo "my uncommitted work"
    --- running the validator
    Processing hello-world
    1..1
    ok 1 test_say_hi
    --- git diff AFTER running the validator
    diff --git a/exercises/practice/hello-world/hello_world.sh b/exercises/practice/hello-world/hello_world.sh
    index 5f126f0..52013e7 100644
    --- a/exercises/practice/hello-world/hello_world.sh
    +++ b/exercises/practice/hello-world/hello_world.sh
    @@ -1,3 +1,4 @@
     #!/usr/bin/env bash
     
     echo "Goodbye, Mars!"
    +echo "my uncommitted work"
    --- files left in the temp directory:        0

## Failing tests
With a broken example solution (`failure_demo.sh`, on a copy outside the repo):
    validator exit status: 1  (non-zero means failure was reported)
    stub restored: yes
    files left in the temp directory:        0

## Other checks
- Interrupting the validator with `kill -TERM` while the tests run leaves the stub
  intact and removes the backup (checked in a Linux sandbox). `kill -9` cannot be
  trapped by any script; the old `git checkout` approach had the same limit.
- `shellcheck bin/validate_one_exercise bin/validate_exercises .github/scripts/ci`
  passes.
- `bin/validate_one_exercise exercises/practice/hello-world`: `ok 1 test_say_hi`.
- `bin/validate_exercises` over the whole track: see
  `validate_exercises_tail.txt`.

## Environment notes
- On macOS the validator was run with GNU grep (the stock grep lacks `-P`),
  `bats-core`, bash 5, `jq` and `shellcheck` from Homebrew.
