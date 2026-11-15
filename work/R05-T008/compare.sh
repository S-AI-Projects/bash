#!/usr/bin/env bash
# Compare save-the-cow with three other difficulty-4 exercises:
# number of tests, lines in the example solution, and topics.
cd "$(dirname "${BASH_SOURCE[0]}")/../.." || exit 1

printf '| exercise | difficulty | tests | example lines | topics |\n'
printf '|---|---|---|---|---|\n'
for slug in save-the-cow pig-latin diamond kindergarten-garden; do
    dir=exercises/practice/${slug}
    tests=$(grep -cE '^(test_|@test)' "${dir}"/*.bats)
    lines=$(wc -l < "${dir}/.meta/example.sh" | tr -d ' ')
    difficulty=$(jq -r --arg s "${slug}" \
        '.exercises.practice[] | select(.slug == $s) | .difficulty' config.json)
    topics=$(jq -r --arg s "${slug}" \
        '.exercises.practice[] | select(.slug == $s) | (.topics // []) | join(", ")' config.json)
    printf '| %s | %s | %s | %s | %s |\n' \
        "${slug}" "${difficulty}" "${tests}" "${lines}" "${topics:-none}"
done
