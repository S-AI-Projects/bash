#!/usr/bin/env bash
# Generates mutants of yacht's .meta/example.sh into ./mutants/.
# Each mutant has exactly ONE targeted small change.
set -euo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(cd "$here/../.." && pwd)
src=$root/exercises/practice/yacht/.meta/example.sh

mkdir -p "$here/mutants"
rm -f "$here"/mutants/*.sh
orig=$(<"$src")

mutate() {
    local name=$1 old=$2 new=$3
    if [[ $orig != *"$old"* ]]; then
        echo "Pattern not found for $name" >&2
        return 1
    fi
    printf '%s\n' "${orig/"$old"/"$new"}" > "$here/mutants/$name.sh"
    chmod +x "$here/mutants/$name.sh"
}

# 1. Flip comparison in yacht: == 1 -> != 1
mutate m01_flip_yacht_cmp \
    '(( ${#grp[@]} == 1 ))' \
    '(( ${#grp[@]} != 1 ))'

# 2. Drop choice calculation (covers 'Yacht as choice' path)
mutate m02_drop_choice_case \
    'choice)            sum $@ ;;' \
    'choice)            echo 0 ;;'

# 3. Change boundary in four_of_a_kind: [45] -> 4 (fails when Yacht scored as Four of a Kind)
mutate m03_four_of_a_kind_boundary \
    '[[ ${grp[die]} == [45] ]]' \
    '[[ ${grp[die]} == 4 ]]'

# 4. Change straight comparison boundary in straight(): 23456 -> 23455
mutate m04_straight_boundary \
    'cmp=12345 || cmp=23456' \
    'cmp=12345 || cmp=23455'

# 5. In full_house, only check 2 distinct groups without checking counts 2 and 3
mutate m05_full_house_two_groups \
    'case ${grp[die]} in
                2|3) sum $@ ;;
                *) echo 0 ;;
            esac' \
    'sum $@'

# 6. In full_house, accept count 4 in addition to 2 and 3 (full house vs four-of-a-kind edge case)
mutate m06_full_house_accept_four \
    '2|3)' \
    '2|3|4)'

# 7. In full_house, accept any count other than 1 ([^1]) (full house vs four-of-a-kind edge case)
mutate m07_full_house_not_one \
    '2|3)' \
    '[^1])'

echo "Generated $(ls -1 "$here"/mutants/*.sh | wc -l) mutants in $here/mutants:"
ls -1 "$here/mutants"
