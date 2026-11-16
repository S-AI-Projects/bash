# R05-T030 — Add 'resistor-color-tolerance' Practice Exercise

## Summary

Ported the `resistor-color-tolerance` exercise from Exercism problem-specifications into the Bash track.
Decodes 1, 4, or 5 resistor color bands into a formatted human-readable resistance label with unit and tolerance:
- 1 band: `0 ohms`
- 4 bands: 2 value digits + multiplier + tolerance (e.g. `33 ohms ±2%`)
- 5 bands: 3 value digits + multiplier + tolerance (e.g. `2.54 megaohms ±1%`)

## Implementation Details

- Created `exercises/practice/resistor-color-tolerance/`:
  - `resistor_color_tolerance.sh` (stub implementation)
  - `.meta/example.sh` (idiomatic solution with pure Bash unit and precision formatting)
  - `.meta/config.json` (exercise configuration)
  - `.meta/tests.toml` (13 canonical cases sync)
  - `.meta/template.j2` (test generation template)
  - `resistor_color_tolerance.bats` (generated Bats test file)
- Added `resistor-color-tolerance` entry to track `config.json`.

## Validation

- Test generation: `bin/generate_tests --no-pull resistor-color-tolerance` — generated 12 active test cases.
- Exercise validator: `bin/validate_one_exercise exercises/practice/resistor-color-tolerance` — all 12 tests passed.
- ShellCheck: `shellcheck exercises/practice/resistor-color-tolerance/.meta/example.sh` — passed with 0 warnings.
- Track linting: `bin/configlet lint` — completed with no issues on the new exercise.
