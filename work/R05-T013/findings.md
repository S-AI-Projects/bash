# Task R05-T013 Findings: Mutation Testing & Test Gap in 'allergies'

## Student Information
- Name: ARYA PRAJAPATI
- Task ID: R05-T013
- Issue: #17

## Mutants Overview
Six mutants were planted in `exercises/practice/allergies/.meta/example.sh`:

1. **Mutant 1 (`mutant1.sh`)** - Changes bit position: `1 << (idx + 1)` instead of `1 << idx`.
   - Result against 50 original tests: KILLED by `not ok 2 testing for eggs allergy:allergic only to eggs`.
2. **Mutant 2 (`mutant2.sh`)** - Changes bit position: `2 << idx` instead of `1 << idx`.
   - Result against 50 original tests: KILLED by `not ok 2 testing for eggs allergy:allergic only to eggs`.
3. **Mutant 3 (`mutant3.sh`)** - Flips comparison: `== 0` instead of `!= 0` in `index_test`.
   - Result against 50 original tests: KILLED by `not ok 1 testing for eggs allergy:not allergic to anything`.
4. **Mutant 4 (`mutant4.sh`)** - Drops an allergen: removes `cats` from `allergens` array.
   - Result against 50 original tests: KILLED by `not ok 37 testing for cats allergy:allergic only to cats`.
5. **Mutant 5 (`mutant5.sh`)** - Changes boundary: `(( $# <= 2 ))` instead of `(( $# < 2 ))`.
   - Result against 50 original tests: KILLED by `not ok 41 list when::no allergies`.
6. **Mutant 6 (`mutant6.sh`)** - Changes score > 255 handling by improperly rejecting scores >= 512: `(( code >= 512 )) && return`.
   - Result against 50 original tests: **SURVIVED** (All 50 tests passed because the maximum score tested was 509).

## Gap Resolution
- Added a new track-specific test in `exercises/practice/allergies/.meta/template.j2`:
  ```bats
  @test 'list when::ignore non allergen score parts above 512' {
      [[ $BATS_RUN_SKIPPED == "true" ]] || skip
      run bash {{ solution }} 513 list

      assert_success
      assert_output "eggs"
  }
  ```
- Regenerated `allergies.bats` now contains 51 tests.
- When running the updated test suite, Mutant 6 is now **KILLED** by test 51:
  `not ok 51 list when::ignore non allergen score parts above 512`.
- `example.sh` passes all 51 tests cleanly.
