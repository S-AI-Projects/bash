#!/usr/bin/env bash
# comparison.sh: compares eliuds-eggs with 3 other difficulty-3 exercises using jq

set -euo pipefail

echo "=== Exercise Comparison (Difficulty 3) ==="
jq -r '.exercises.practice[] | select(.slug | IN("eliuds-eggs", "collatz-conjecture", "darts", "square-root")) | 
  "Exercise: \(.slug) (Difficulty: \(.difficulty))\nTopics:   \(.topics | join(", "))\n"' config.json
