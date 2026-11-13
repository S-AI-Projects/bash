# R05-T002: beer-song test template

## Goal
`beer-song` had no `.meta/template.j2`, so its 11 Bats tests could not be
regenerated from the canonical data. I wrote a template that reproduces the
committed `beer_song.bats` exactly.

## What I read first
- `bin/generate_tests`: the template receives `cases`, `header` and `solution`.
  Cases are flattened from `canonical-data.json` and filtered by `tests.toml`.
- `two-fer/.meta/template.j2` as a model for the loop, the `loop.first` skip
  handling and the hand-written track-only tests.
- `beer-song/.meta/example.sh`, to confirm the error messages used by the
  track-only tests.

## Template design
- **Canonical tests (8):** one loop over `cases`.
- **Track-only tests (3):** `no_arguments`, `too_many_arguments` and
  `wrong_order_arguments` are hand-written after the loop, because they are
  not in the canonical data.
- **Skip line:** only the first test has the commented skip line
  (`#[[ $BATS_RUN_SKIPPED == "true" ]] || skip`, no space after `#`). Every
  other test has the active line (the validator's rule).
- **Arguments:** one verse is `startBottles`; a range is `startBottles` and
  `startBottles - takeDown + 1` (99/2 -> `99 98`, 2/3 -> `2 0`, 99/100 -> `99 0`).

## Things the template has to handle to match the committed file
1. **Test names.** The committed names differ from the canonical descriptions
   (for example "last generic verse" is `3rd_last_generic_verse`, "verse with 1
   bottle" is `penultimate_verse`), so the template maps each canonical uuid to
   the committed name.
2. **Test syntax.** The file uses `@test 'name' {`, not the generator's default
   `test_name() { # @test`, so the template writes that line itself.
3. **Header.** The committed header has `# local version: 2.1.0.1`. The
   template writes the header lines directly instead of using `{{ header }}`,
   because `{{ header }}` produces `# generated on ...`, which would show up as
   a real change in the diff.
4. **Formatting quirks of the committed file.** `last_three_verses` has
   `expected=` indented 8 spaces; `last_three_verses` and `all_verses` have a
   blank line before `run`; `first_two_verses` does not. The template
   reproduces these with the `takeDown` value (`== 3` and `> 2`).

## Results
- `python3 bin/generate_tests beer-song` leaves `beer_song.bats` unchanged
  (`git status --short` shows no modification).
- `git diff --exit-code -I '^# generated on' exercises/practice/beer-song/beer_song.bats`: passes.
- `bin/validate_one_exercise exercises/practice/beer-song`: 11 of 11 tests ok
  (tests 1-8 canonical, tests 9-11 track-only).
- `bin/configlet lint`: passes (basic linting finished successfully).

## Environment notes
- My copy of `bin/generate_tests` has no `--no-pull` flag (pulling is off by
  default; `--pull` enables it), so I ran `python3 bin/generate_tests beer-song`.
  It reads a local `problem-specifications` clone linked into
  `~/.cache/exercism/configlet/problem-specifications`.
- On macOS the validator was run with GNU grep (the stock grep lacks `-P`),
  `bats-core` and bash 5 from Homebrew. The system bash 3.2 fails on
  `local -u` in `example.sh`, so the verse tests only pass under bash 4 or newer.

## Decision
Added only `exercises/practice/beer-song/.meta/template.j2`. `beer_song.bats`
was not edited by hand.
