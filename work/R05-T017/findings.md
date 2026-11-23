# Task R05-T017 Findings: Write instructions.append.md for 'nucleotide-count'

## Student Information
- Name: ARYA PRAJAPATI
- Task ID: R05-T017
- Issue: #21

## Summary of Additions
Created `exercises/practice/nucleotide-count/.docs/instructions.append.md` containing Bash-specific guidance:
1. **Associative Arrays (`declare -A`)**:
   - Introduced key-value mapping with Bash associative arrays for tallying character counts.
   - Provided verified initialization and increment syntax without giving away the full loop.
2. **Input Validation**:
   - Outlined checking for invalid characters and returning non-zero error status with the expected error message `"Invalid nucleotide in strand"`.
   - Demonstrated pattern matching (`*[^ACGT]*`) and regex matching (`=~ [^ACGT]`) syntax inside `[[ ... ]]`.

## Verification
- Verified all mini-examples with `work/R05-T017/verify_hints.sh`.
- `bin/validate_one_exercise exercises/practice/nucleotide-count` passes all 5 tests.
- Formatting and markdown verified against standards.
