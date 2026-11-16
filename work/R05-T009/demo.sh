#!/usr/bin/env bash
# Demo: does the validator keep an uncommitted edit to the hello-world stub?
# usage: bash work/R05-T009/demo.sh <path to validate_one_exercise>
# Run it from the repository root.
validator=$1
exercise=exercises/practice/hello-world
stub=${exercise}/hello_world.sh
tmpdir=$(mktemp -d)

# An uncommitted edit to the stub.
echo 'echo "my uncommitted work"' >> "${stub}"

echo '--- git diff BEFORE running the validator'
git diff --no-color -- "${stub}"

echo '--- running the validator'
TMPDIR=${tmpdir} bash "${validator}" "${exercise}" 2>&1 | tail -4

echo '--- git diff AFTER running the validator'
git diff --no-color -- "${stub}"

echo "--- files left in the temp directory: $(find "${tmpdir}" -type f | wc -l)"

# Put the repository back the way it was.
git checkout -- "${stub}"
rm -rf "${tmpdir}"
