#!/usr/bin/env bash
# Verification of excluded cases for anagram against example.sh

EXAMPLE="exercises/practice/anagram/.meta/example.sh"

echo "=== Testing Case 1: b3cca662-f50a-489e-ae10-ab8290a09bdc ==="
# subject="master", candidates=["stream", "pigeon", "maters"]
# expected: stream maters
bash "$EXAMPLE" "master" "stream pigeon maters"

echo "=== Testing Case 2: 7cc195ad-e3c7-44ee-9fd2-d3c344806a2c ==="
# subject="go", candidates=["go Go GO"]
# Note: candidate contains spaces
bash "$EXAMPLE" "go" "go Go GO"

echo "=== Testing Case 3: 85757361-4535-45fd-ac0e-3810d40debc1 ==="
# subject="BANANA", candidates=["BANANA", "Banana", "banana"]
bash "$EXAMPLE" "BANANA" "BANANA Banana banana"

echo "=== Testing Case 4: a0705568-628c-4b55-9798-82e4acde51ca ==="
# subject="LISTEN", candidates=["Listen", "Silent", "LISTEN"]
bash "$EXAMPLE" "LISTEN" "Listen Silent LISTEN"
