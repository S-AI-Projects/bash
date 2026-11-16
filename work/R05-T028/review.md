# R05-T028 — Fix 'line-up' Metadata

## Summary

`line-up` was missing topic tags in `config.json` despite being classified at difficulty level 2 in the learning path.
Updated `config.json` to assign topics that reflect its core educational concepts:
- `control_flow_conditionals`
- `pattern_matching`
- `strings`
- `text_formatting`

## Verification

- Automated check:
  `jq -e '.exercises.practice[] | select(.slug=="line-up") | .topics | length > 0' config.json` — PASSED.
- Compared `line-up` against 3 other difficulty-2 exercises (`raindrops`, `hamming`, `pangram`) in `work/R05-T028/comparison.md`.
- `bin/configlet lint` — completed; validated track configuration.
