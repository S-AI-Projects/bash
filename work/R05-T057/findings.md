# R05-T057 — Write `instructions.append.md` for `acronym`

**Student:** Harshit Dhablia (E26B07F1068)  
**Task:** R05-T057 · 7 of 10  
**Issue:** https://github.com/S-AI-Projects/bash/issues/57  
**Target:** `exercises/practice/acronym/.docs/instructions.append.md`  

---

## 1. Goal & Requirements

Add Bash-specific instructions for the `acronym` practice exercise without giving away the complete solution:
- Cover pathname expansion (globbing) hazards and the interaction between word splitting and globbing.
- Explain `set -f` (`noglob`) and variable quoting to handle characters such as `*` (specifically targeting test 10: "contains shell globbing character" with input `"Two * Words"`).
- Explain word separation with hyphens and uppercase conversion using parameter expansion.
- Link relevant sections of the GNU Bash Reference Manual.
- Pass `bin/configlet lint` and `npx markdownlint-cli2`.
- Keep personal working solution in `work/R05-T057/solution.sh`.

---

## 2. Verified Concept Examples

### Example 1: Globbing Hazard Without `set -f`
```bash
phrase="Two * Words"
count=0
for w in $phrase; do
  count=$(( count + 1 ))
done
echo "Expanded words count: $count" # Count: 17 (expanded all files in working directory!)
```

### Example 2: With `set -f`
```bash
set -f
for w in $phrase; do
  echo "word: $w"
done
set +f
# Outputs:
# word: Two
# word: *
# word: Words
```

### Example 3: Parameter Expansion
```bash
phrase="liquid-crystal"
clean="${phrase//-/ }"     # "liquid crystal"
upper="${clean^^}"         # "LIQUID CRYSTAL"
```

---

## 3. Validation Results

| Check | Command | Result |
|---|---|---|
| Markdownlint | `npx --yes markdownlint-cli2 exercises/practice/acronym/.docs/instructions.append.md` | **0 issues (exit 0)** |
| Configlet Lint | `bin/configlet lint` | **Clean on `acronym`** (only pre-existing track-wide `docs/SIGN_UP_SNIPPET.txt`) |
| Exercise Validator | `bin/validate_one_exercise exercises/practice/acronym` | **10/10 tests passed (exit 0)** |
| Standalone Solution | `bats acronym.bats` (using `work/R05-T057/solution.sh`) | **10/10 tests passed (exit 0)** |
| Diff Check | `git diff --check` | **Clean (exit 0)** |
