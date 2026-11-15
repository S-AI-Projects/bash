BATS_RUN_SKIPPED=true
skip() { :; }
run() { output=$("$@" 2>&1); status=$?; }
assert_success() { [[ $status -eq 0 ]] || { echo "assert_success failed: status=$status output=$output" >&2; return 1; }; }
assert_output() { [[ $output == "$1" ]] || { echo "assert_output failed: got '$output' want '$1'" >&2; return 1; }; }
assert_equal() { [[ $1 == "$2" ]] || { echo "assert_equal failed: '$1' != '$2'" >&2; return 1; }; }
assert() { "$@" || { echo "assert failed: $*" >&2; return 1; }; }
