# R05-T027 — Secret Handshake Bash Guidance

## Summary

Added `exercises/practice/secret-handshake/.docs/instructions.append.md` containing Bash-specific guidance and hints for learners solving the exercise:
- Bitwise operations in Bash arithmetic evaluation `(( number & 1 ))` and shifts `(( number & (1 << i) ))`.
- In-place array reversal using reverse indexing.
- Handling of input `0` ("do nothing for zero").
- Joining array elements with a comma delimiter using local `IFS`.

## Verification

- Markdownlint: `npx --yes markdownlint-cli2 exercises/practice/secret-handshake/.docs/instructions.append.md` — passed with 0 errors.
- Track linter: `bin/configlet lint` — completed with no issues on the exercise documentation.
- Solution verification: Verified student solution in `work/R05-T027/solution.sh` against all 11 Bats tests using `work/R05-T027/verify_hints.sh`.
