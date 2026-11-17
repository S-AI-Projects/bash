#!/usr/bin/env bash

# usage: matrix.sh <matrix> {row|column} <index>
#
# <matrix> is one string: rows are separated by newlines, numbers by spaces.
# <index> starts at 1. The numbers of the row or column are printed on one
# line, separated by spaces.

declare -a rows=()

die() {
    echo "$*" >&2
    exit 1
}

# Print row number $1.
row() {
    local -a cells
    read -r -a cells <<< "${rows[$1 - 1]}"
    echo "${cells[*]}"
}

# Print column number $1.
column() {
    local -a cells
    local -a result=()
    local line
    for line in "${rows[@]}"; do
        read -r -a cells <<< "${line}"
        result+=( "${cells[$1 - 1]}" )
    done
    echo "${result[*]}"
}

main() {
    (( $# == 3 )) || die "Usage: matrix.sh <matrix> {row|column} <index>"

    local matrix=$1 property=$2 index=$3
    [[ ${index} =~ ^[1-9][0-9]*$ ]] || die "index must be a positive integer"

    readarray -t rows <<< "${matrix}"

    case ${property} in
        row)
            (( index <= ${#rows[@]} )) || die "index out of range"
            row "${index}"
            ;;
        column)
            local -a first
            read -r -a first <<< "${rows[0]}"
            (( index <= ${#first[@]} )) || die "index out of range"
            column "${index}"
            ;;
        *) die "property must be 'row' or 'column'" ;;
    esac
}

main "$@"
