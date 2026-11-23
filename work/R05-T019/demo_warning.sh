#!/usr/bin/env bash
# Demonstration of bin/validate_one_exercise detecting a missing test case from tests.toml
set -euo pipefail

export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:/opt/homebrew/opt/grep/libexec/gnubin:$PWD/bin:$PATH"

scratch_dir=$(mktemp -d -t house_scratch_XXXXXX)
trap 'rm -rf "${scratch_dir}"' EXIT

echo "=== Setting up scratch copy of exercises/practice/house ==="
cp -r exercises/practice/house "${scratch_dir}/house"

(
    cd "${scratch_dir}/house"
    git init -q
    git config user.name "tester"
    git config user.email "tester@example.com"
    git add .
    git commit -qm "initial commit"
)

echo
echo "=== Baseline: running validator on unmodified house exercise ==="
bin/validate_one_exercise "${scratch_dir}/house"

echo
echo "=== Mutating house.bats: deliberately rename 'full rhyme' test ==="
sed -i.bak 's/@test "full rhyme"/@test "deliberately renamed rhyme"/' "${scratch_dir}/house/house.bats"

echo
echo "=== Running validator on mutated scratch copy (warning expected) ==="
bin/validate_one_exercise "${scratch_dir}/house" || true
