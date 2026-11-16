# Task R05-T037: Write instructions.append.md for 'isbn-verifier' (Issue #39)

## Overview & Objectives
Provide idiomatic Bash-specific guidance in `exercises/practice/isbn-verifier/.docs/instructions.append.md` that is presented to learners following the problem's shared instructions. The guidance provides 4 targeted hints pointing learners toward idiomatic Bash features without spoiling the solution or giving away full algorithms.

---

## Reference Solution (`work/R05-T037/solution.sh`)

Before authoring guidance, the exercise was solved independently in `work/R05-T037/solution.sh`. The solution follows the Google Shell Style Guide, passes `shellcheck -o all` cleanly, and successfully passes all 21 test cases in `isbn_verifier.bats`.

```bash
#!/usr/bin/env bash
#
# Verify whether a given string is a valid ISBN-10 number.

set -o errexit
set -o nounset

#######################################
# Validate an ISBN-10 string.
# Arguments:
#   Input candidate string
# Outputs:
#   "true" if valid ISBN-10, "false" otherwise
#######################################
main() {
  local input="${1:-}"
  local isbn="${input//-/}"
  local -i sum=0 weight=10
  local -i i val

  # The ISBN must consist of exactly 9 digits followed by 1 digit or 'X'.
  if ! [[ "${isbn}" =~ ^[0-9]{9}[0-9X]$ ]]; then
    echo "false"
    return 0
  fi

  for (( i = 0; i < 9; i++ )); do
    val="${isbn:i:1}"
    (( sum += val * weight ))
    (( weight-- ))
  done

  if [[ "${isbn:9:1}" == "X" ]]; then
    (( sum += 10 ))
  else
    val="${isbn:9:1}"
    (( sum += val ))
  fi

  if (( sum % 11 == 0 )); then
    echo "true"
  else
    echo "false"
  fi
}

main "${@}"
```

### Static Analysis (`shellcheck -o all work/R05-T037/solution.sh`)
Output recorded in `work/R05-T037/shellcheck_solution.txt`:
*0 diagnostic messages (clean).*

### Bats Test Suite Verification (21/21 Tests Passed)
Ran against `exercises/practice/isbn-verifier/isbn_verifier.bats` (output recorded in `work/R05-T037/test_output.txt`):
```text
1..21
ok 1 valid isbn
ok 2 invalid isbn check digit
ok 3 valid isbn with a check digit of 10
ok 4 check digit is a character other than X
ok 5 invalid check digit in isbn is not treated as zero
ok 6 invalid character in isbn is not treated as zero
ok 7 X is only valid as a check digit
ok 8 only one check digit is allowed
ok 9 X is not substituted by the value 10
ok 10 valid isbn without separating dashes
ok 11 isbn without separating dashes and X as check digit
ok 12 isbn without check digit and dashes
ok 13 too long isbn and no dashes
ok 14 too short isbn
ok 15 isbn without check digit
ok 16 check digit of X should not be used for 0
ok 17 empty isbn
ok 18 input is 9 characters
ok 19 invalid characters are not ignored after checking length
ok 20 invalid characters are not ignored before checking length
ok 21 input is too long but contains a valid isbn
```

---

## Instructions Append Content & Design

Following the track conventions established in `darts/.docs/instructions.append.md` and `list-ops/.docs/instructions.append.md`, the document uses `# Dummy header` (which Exercism's document pipeline strips when appending) followed by an H2 section.

The hints address key Bash concepts required for the problem:
1. **Removing separating hyphens:** Demonstrates pattern substitution `${isbn//-/}`.
2. **Format and length validation:** Explains regex matching with `=~` in `[[ ... ]]`, emphasizing the need to anchor patterns (`^...$`) to avoid accepting substrings from over-length inputs like `'input is too long but contains a valid isbn'` (`98245726788`).
3. **Handling the 'X' check character:** Demonstrates substring expansion `${clean:9:1}` and mapping `'X'` to numeric value `10`.
4. **Character iteration and arithmetic evaluation:** Demonstrates accumulator loops and modulo checking with `(( sum % 11 == 0 ))`.

Official GNU Bash manual links are included for all referenced language features:
- [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)
- [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)
- [Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)

---

## Execution Verification of Code Examples

Every snippet included in `instructions.append.md` was executed directly in Bash to verify correctness (recorded in `work/R05-T037/snippet_verification.txt`):

```text
=== Snippet 1: Removing separating hyphens ===
3598215088

=== Snippet 2: Format and length validation ===
Valid format
Correctly rejected too-long string

=== Snippet 3: Handling the 'X' check character ===
Check digit value: 10

=== Snippet 4: Character iteration and arithmetic evaluation ===
valid
```

---

## Linter & Sync Verification

### 1. Markdown Linter (`npx markdownlint-cli2`)
Executed on `exercises/practice/isbn-verifier/.docs/instructions.append.md` (recorded in `work/R05-T037/markdownlint_output.txt`):
```text
markdownlint-cli2 v0.24.1 (markdownlint v0.42.1)
Finding: exercises/practice/isbn-verifier/.docs/instructions.append.md
Linting: 1 file
Summary: 0 issues in 0 files
```

### 2. Configlet Sync (`bin/configlet sync -e isbn-verifier`)
Output recorded in `work/R05-T037/configlet_sync.txt`:
```text
Updating cached 'problem-specifications' data...
Checking exercises...
The `isbn-verifier` exercise has up-to-date docs, filepaths, metadata, and tests!
```

### 3. Configlet Lint (`bin/configlet lint`)
Output recorded in `work/R05-T037/configlet_lint.txt`:
```text
The lint command is under development.
To check your track using the latest linting rules,
please regularly update configlet and re-run this command.

Basic linting finished successfully:
- config.json exists and is valid JSON
- config.json has these valid fields:
    language, slug, active, blurb, version, status, online_editor, key_features, tags
- Every concept has the required .md files
- Every concept has a valid links.json file
- Every concept has a valid .meta/config.json file
- Every concept exercise has the required .md files
- Every concept exercise has a valid .meta/config.json file
- Every practice exercise has the required .md files
- Every practice exercise has a valid .meta/config.json file
- Every approach and article is valid
- Required track docs are present
- Required shared exercise docs are present
```

---

## Working Tree & Exercise Stub Hygiene
- The exercise stub `exercises/practice/isbn-verifier/isbn_verifier.sh` was never modified and remains identical to `main`.
- Only `exercises/practice/isbn-verifier/.docs/instructions.append.md` and `work/R05-T037/` are committed.
