#!/usr/bin/env bash
# Generates mutants of clock's .meta/example.sh into ./mutants/.
# Each mutant is the original with exactly ONE small change.
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(cd "$here/../.." && pwd)
src=$root/exercises/practice/clock/.meta/example.sh
mkdir -p "$here/mutants"
rm -f "$here"/mutants/*.sh
orig=$(<"$src")

mutate() {  # name, text to find, replacement
    local name=$1 old=$2 new=$3
    if [[ $orig != *"$old"* ]]; then
        echo "pattern not found for $name" >&2
        return 1
    fi
    printf '%s\n' "${orig/"$old"/"$new"}" > "$here/mutants/$name.sh"
}

mutate m01_carry_two_hours      '((m += 60, h -= 1))'  '((m += 60, h -= 2))'
mutate m02_wrap_23_hours        'minutes % (24 * 60)'  'minutes % (23 * 60)'
mutate m03_minutes_mod_59       '$((minutes % 60))'    '$((minutes % 59))'
mutate m04_drop_hours_mod       '(minutes / 60) % 24'  '(minutes / 60)'
mutate m05_negative_fix_once    'while ((minutes < 0)); do ((minutes += (24*60))); done' \
                                '((minutes < 0)) && ((minutes += 24*60))'
mutate m06_negative_fix_max_2   'while ((minutes < 0)); do ((minutes += (24*60))); done' \
                                'for _ in 1 2; do ((minutes < 0)) && ((minutes += 24*60)); done'
mutate m07_negative_fix_max_5   'while ((minutes < 0)); do ((minutes += (24*60))); done' \
                                'for _ in 1 2 3 4 5; do ((minutes < 0)) && ((minutes += 24*60)); done'
mutate m08_negative_boundary    'while ((minutes < 0))' 'while ((minutes < -1))'
mutate m09_drop_negative_hours  'while ((h < 0)); do ((h += 24)); done'  ':'
mutate m10_drop_negative_mins   'while ((m < 0)); do ((m += 60, h -= 1)); done'  ':'
mutate m11_equal_inverted       '&& echo true || echo false'  '&& echo false || echo true'
ls "$here/mutants"
