#!/bin/bash
# Mutant 6: mishandles scores >= 512 by resetting code to 0 (survives 50 tests because max tested score is 509)

allergens=(
  eggs peanuts shellfish strawberries
  tomatoes chocolate pollen cats
)

main() {
    if (( $# < 2 )); then
        echo "usage: ${0##*/} <code> list" >&2
        echo "usage: ${0##*/} <code> allergic_to <allergen>" >&2
        exit 255
    fi

    local code=$1
    local cmd=$2

    case $cmd in
        list)
            list_allergies "$code"
            ;;
        allergic_to)
            if [[ -z "$3" ]]; then
                echo "error: missing argument" >&2
                exit 1
            fi
            is_allergic_to "$code" "$3"
            ;;
    esac
}

index_test() {
    local code=$1 idx=$2
    (( (code & (1 << idx)) != 0 ))
}

list_allergies() {
    local code=$1
    # Buggy assumption: assumes scores >= 512 are invalid or ignored
    if (( code >= 512 )); then
        echo ""
        return
    fi

    local allergies=()
    local i
    for i in "${!allergens[@]}"; do
        if index_test "$code" "$i"; then
            allergies+=( "${allergens[i]}" )
        fi
    done
    echo "${allergies[*]}"
}

is_allergic_to() {
    local code=$1
    local allergen=$2
    local i
    for i in "${!allergens[@]}"; do
        if  [[ ${allergens[i]} == "$allergen" ]] &&
            index_test "$code" "$i"
        then
            echo "true"
            exit
        fi
    done
    echo "false"
}

main "$@"
