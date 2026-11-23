# Task R05-T011 Findings: Resolve Unexplained Exclusions in 'anagram'

## Student Information
- Name: ARYA PRAJAPATI
- Task ID: R05-T011
- Issue: #2

## Analysis of Excluded Cases in `canonical-data.json`

Four canonical test cases in `exercises/practice/anagram/.meta/tests.toml` were excluded (`include = false`) without explanations. Each was verified against `canonical-data.json` and `.meta/example.sh`:

1. **UUID `b3cca662-f50a-489e-ae10-ab8290a09bdc`**: "detects two anagrams"
   - In `canonical-data.json`, newer UUID `03eb9bbe-8906-4ea0-84fa-ffe711b52c8b` explicitly has `reimplements = "b3cca662-f50a-489e-ae10-ab8290a09bdc"` with comment: "Reimplemented to be consistent about removing references to 'master'".
   - The newer test case is active and included. The older one is obsolete/deprecated.
   - Comment added: `reimplemented by 03eb9bbe-8906-4ea0-84fa-ffe711b52c8b`.

2. **UUID `7cc195ad-e3c7-44ee-9fd2-d3c344806a2c`**: "does not detect an anagram if the original word is repeated"
   - In `canonical-data.json`, newer UUID `630abb71-a94e-4715-8395-179ec1df9f91` has `reimplements = "7cc195ad-e3c7-44ee-9fd2-d3c344806a2c"`.
   - The original test case passed a space-separated string `"go Go GO"` as a single candidate; the reimplemented test uses `"goGoGO"`.
   - Comment added: `reimplemented by 630abb71-a94e-4715-8395-179ec1df9f91`.

3. **UUID `85757361-4535-45fd-ac0e-3810d40debc1`**: "words are not anagrams of themselves (case-insensitive)"
   - In `canonical-data.json`, this test case was superseded and split into three separate tests:
     - `68934ed0-010b-4ef9-857a-20c9012d1ebf` ("words are not anagrams of themselves")
     - `589384f3-4c8a-4e7d-9edc-51c3e5f0c90e` ("words are not anagrams of themselves even if letter case is partially different")
     - `ba53e423-7e02-41ee-9ae2-71f91e6d18e6` ("words are not anagrams of themselves even if letter case is completely different")
   - All three newer cases are included.
   - Comment added: `reimplemented by 68934ed0-010b-4ef9-857a-20c9012d1ebf, 589384f3-4c8a-4e7d-9edc-51c3e5f0c90e, and ba53e423-7e02-41ee-9ae2-71f91e6d18e6`.

4. **UUID `a0705568-628c-4b55-9798-82e4acde51ca`**: "words other than themselves can be anagrams"
   - In `canonical-data.json`, newer UUID `33d3f67e-fbb9-49d3-a90e-0beb00861da7` has `reimplements = "a0705568-628c-4b55-9798-82e4acde51ca"`.
   - The newer test case is included.
   - Comment added: `reimplemented by 33d3f67e-fbb9-49d3-a90e-0beb00861da7`.

## Verification
- Two existing Unicode comments remain unchanged.
- Regenerated `anagram.bats` produces identical test cases.
- All 16 tests pass via `bin/validate_one_exercise exercises/practice/anagram`.
