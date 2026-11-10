# R05-T001: hamming excluded canonical cases

## Method
Copied `exercises/practice/hamming/.meta/example.sh` to a scratch directory
and ran the input of each excluded case against it.

## Results

| Input (strand1, strand2) | Output | Exit code |
|---|---|---|
| `AATG`, `AAA` | left and right strands must be of equal length | 1 |
| `ATA`, `AGTG` | left and right strands must be of equal length | 1 |
| `""`, `G` | left and right strands must be of equal length | 1 |
| `G`, `""` | left and right strands must be of equal length | 1 |

## Findings
- `example.sh` only checks for a length mismatch. It never prints
  "left strand must not be empty" or "right strand must not be empty", so
  the original empty-strand cases (5dce058b, 38826d4b) cannot be supported
  without adding checks that the newer canonical versions removed.
- All four inputs are already tested in `hamming.bats` with
  `--partial "strands must be of equal length"`.
- All six excluded cases are older versions superseded via `reimplements`,
  and the four newest versions are already included in `tests.toml`.
- Including the old versions would generate duplicate test names.
- Decision: keep all six excluded and add a `comment` to each.