# R05-T023 — Roman Numerals Mutation Testing

## Summary

Performed mutation testing on `exercises/practice/roman-numerals` to identify gaps in test coverage around subtractive pairs (IV, IX, XL, XC, CD, CM). Closed the gap by introducing a track-specific test for combined subtractive pairs (`444 is CDXLIV`) in `template.j2`, bringing the test suite from 27 to 28 passing tests.

## Mutation Analysis

Six mutants were implemented in `work/R05-T023/mutants/`:
1. `mutant1_iv.sh`: Changed `[4]=IV` to `[4]=IIII` (Subtractive pair IV) — **KILLED** by test `4 is IV`.
2. `mutant2_ix.sh`: Changed `[9]=IX` to `[9]=VIIII` (Subtractive pair IX) — **KILLED** by test `9 is IX`.
3. `mutant3_xl.sh`: Changed `[40]=XL` to `[40]=XXXX` (Subtractive pair XL) — **KILLED** by test `48 is XLVIII`.
4. `mutant4_xc.sh`: Changed `[90]=XC` to `[90]=LXXXX` (Subtractive pair XC) — **KILLED** by test `93 is XCIII`.
5. `mutant5_cd.sh`: Changed `[400]=CD` to `[400]=CCCC` (Subtractive pair CD) — **KILLED** by test `402 is CDII`.
6. `mutant6_pair_combo.sh`: Dropped the subtractive pair `IV` when preceded by `XL` — **SURVIVED** the original 27 canonical tests because no test case previously checked numbers containing both `XL` and `IV` (e.g. `44` or `444`).

## Gap Resolution

- Added a track-specific `@test` block in `exercises/practice/roman-numerals/.meta/template.j2`:
  ```bash
  @test "444 is CDXLIV" {
      [[ $BATS_RUN_SKIPPED == "true" ]] || skip
      run bash {{ solution }} 444
      assert_success
      assert_output "CDXLIV"
  }
  ```
- Regenerated `exercises/practice/roman-numerals/roman_numerals.bats` using `bin/generate_tests --no-pull roman-numerals`.
- The new test exercises three subtractive pairs in a single number: `CD` (400), `XL` (40), and `IV` (4).
- The updated 28-test suite kills `mutant6_pair_combo.sh` while passing completely on `example.sh`.

## Validation

- `bin/validate_one_exercise exercises/practice/roman-numerals` — PASSED (28/28 tests passed).
- `bash work/R05-T023/run_mutants.sh` — PASSED.
