# R05-T042: add .meta/template.j2 for diffie-hellman

## What was added
`exercises/practice/diffie-hellman/.meta/template.j2`: a loop over the canonical cases that dispatches on
`case["property"]`, so the numbers (p, g, private/public keys, expected values) come from the canonical data
and tests.toml, while the track-specific loops stay hand-written.

| Canonical property | Test generated | Notes |
|---|---|---|
| `privateKeyIsInRange` | "private key is in range" | loop over 13 values, `between` helper; name differs from the canonical description, so it is fixed in the template |
| `privateKeyIsRandom` | "private key is random" | loop of 10 runs; uses `${#a[@]}` inside `{% raw %}` because `{#` starts a Jinja comment |
| `publicKey` (x2) | "can calculate public key ..." | p, g, private, expected taken from the case |
| `secret` | "can calculate secret key using other's public key" | name differs from the canonical description, so it is fixed in the template |
| `keyExchange` | "key exchange" | 10-iteration loop, p and g from the case |

The `between()` helper is emitted before the loop. Its line has a trailing space in the committed file; the
template reproduces it with `{{ "{ " }}`.

## Result of regenerating
`python3 bin/generate_tests --no-pull diffie-hellman` reproduces all 6 tests unchanged. The only line that
differs from the committed `diffie_hellman.bats` is the header line (see `regenerate.diff`):
`# local version: 1.0.0.0` becomes `# generated on <timestamp>`. The generator always writes that line, so the
old "local version" marker cannot be kept; the regenerated file is committed so later runs show no diff.

## Verification
- 6/6 tests pass against `.meta/example.sh` (`test_run.out`), run with a small stand-in for bats
  (`bats_shim_pre.sh`) because bats was not available in the environment used.
- Not run in that environment: `bin/validate_one_exercise` (needs bats and GNU grep) and `bin/configlet lint`
  (configlet could not be downloaded). Run both locally before opening the PR.

## Noticed but left alone
The "private key is random" test uses `a["$output"]=1` without declaring `a`; it works but is not an associative
array declaration. Out of scope for this task (the goal is to reproduce the existing tests exactly).
