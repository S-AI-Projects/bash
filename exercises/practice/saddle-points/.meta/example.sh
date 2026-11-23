#!/usr/bin/env bash
#
# Detect saddle points in a matrix.
# A saddle point is an element that is greater than or equal to every element
# in its row and less than or equal to every element in its column.

set -o errexit
set -o nounset

find_saddle_points() {
    local -a rows=("$@")
    local -i num_rows=${#rows[@]}
    (( num_rows == 0 )) && return 0

    # Parse rows into a flat matrix and determine column dimensions
    local -a matrix=()
    local -i num_cols=0
    local -i r c val

    for (( r = 0; r < num_rows; r++ )); do
        local -a cols=()
        read -ra cols <<< "${rows[r]}"
        if (( r == 0 )); then
            num_cols=${#cols[@]}
            (( num_cols == 0 )) && return 0
        fi
        for (( c = 0; c < num_cols; c++ )); do
            matrix[r * num_cols + c]=${cols[c]}
        done
    done

    # Find the maximum value in each row
    local -a row_max=()
    for (( r = 0; r < num_rows; r++ )); do
        local -i max_val=${matrix[r * num_cols + 0]}
        for (( c = 1; c < num_cols; c++ )); do
            val=${matrix[r * num_cols + c]}
            (( val > max_val )) && max_val=${val}
        done
        row_max[r]=${max_val}
    done

    # Find the minimum value in each column
    local -a col_min=()
    for (( c = 0; c < num_cols; c++ )); do
        local -i min_val=${matrix[0 * num_cols + c]}
        for (( r = 1; r < num_rows; r++ )); do
            val=${matrix[r * num_cols + c]}
            (( val < min_val )) && min_val=${val}
        done
        col_min[c]=${min_val}
    done

    # Check for saddle points
    for (( r = 0; r < num_rows; r++ )); do
        for (( c = 0; c < num_cols; c++ )); do
            val=${matrix[r * num_cols + c]}
            if (( val == row_max[r] && val == col_min[c] )); then
                printf "row %d, column %d\n" "$(( r + 1 ))" "$(( c + 1 ))"
            fi
        done
    done
}

main() {
    find_saddle_points "$@"
}

main "$@"
