#!/usr/bin/env bash
# Demo: when the tests fail, the validator still exits non-zero, restores the
# stub, and removes its temp file. Works on a copy of hello-world with a broken
# example, outside the repository, so nothing in the repo is touched.
# usage: bash work/R05-T009/failure_demo.sh   (from the repository root)
root=$(pwd)
work=$(mktemp -d)
tmpdir=$(mktemp -d)
cp -r exercises/practice/hello-world "${work}/hello-world"
echo 'echo "Wrong output"' > "${work}/hello-world/.meta/example.sh"   # broken example
before=$(md5sum < "${work}/hello-world/hello_world.sh" 2>/dev/null || md5 < "${work}/hello-world/hello_world.sh")

TMPDIR=${tmpdir} bash "${root}/bin/validate_one_exercise" "${work}/hello-world" > /dev/null 2>&1
echo "validator exit status: $?  (non-zero means failure was reported)"

after=$(md5sum < "${work}/hello-world/hello_world.sh" 2>/dev/null || md5 < "${work}/hello-world/hello_world.sh")
[[ ${before} == "${after}" ]] && echo "stub restored: yes" || echo "stub restored: NO"
echo "files left in the temp directory: $(find "${tmpdir}" -type f | wc -l)"
rm -rf "${work}" "${tmpdir}"
