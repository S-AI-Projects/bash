#!/usr/bin/env bash

shopt -s extglob

# Shared state: the diagram rows, a "row,col" string for every "+" in the
# diagram, and the width of the widest row.
declare -a rows=()
declare -a vertices=()
declare -i width

# Count the rectangles in the diagram read from stdin.
# Outputs: the count on stdout.
main() {
    local -i count=0 i

    # read the incoming layout from stdin
    [[ -t 0 ]] || readarray -t rows

    # find the max width
    width=${#rows[0]}
    for ((i=1; i<${#rows[@]}; i++)); do
        (( width < ${#rows[i]} )) && width=${#rows[i]}
    done

    find_vertices

    local topL topR bottomL bottomR
    local -i r1 r2 c1 c2

    for topL in "${vertices[@]}"; do
        for topR in $(verts_to_right "${topL}"); do
            for bottomL in $(verts_below "${topL}"); do
                parse_vertex "${bottomL}" r1 c1
                parse_vertex "${topR}"    r2 c2
                bottomR="${r1},${c2}"
                if is_rectangle "${topL}" "${bottomR}"; then
                    ((count++))
                fi
            done
        done
    done

    echo "${count}"
}

# Collect the "row,col" position of every "+" into the global vertices array.
find_vertices() {
    local -i r c
    for ((r=0; r<${#rows[@]}; r++)); do
        for ((c=0; c<width; c++)); do
            if [[ ${rows[r]:c:1} == "+" ]]; then
                vertices+=( "${r},${c}" )
            fi
        done
    done
}

# Split a "row,col" string into two variables, set by name (namerefs).
# Arguments: the vertex, the name of the row variable, the name of the column variable.
# The underscore prefix keeps the namerefs from clashing with the caller's names.
parse_vertex() {
    local vertex=$1
    local -n _row=$2 _col=$3
    _row=${vertex%,*}
    _col=${vertex#*,}
}

# Print every vertex on the same row as the given vertex and to its right.
verts_to_right() {
    local vertex=$1
    local -i r c rr cc
    local v
    parse_vertex "${vertex}" r c
    for v in "${vertices[@]}"; do
        parse_vertex "${v}" rr cc
        (( r == rr && c < cc )) && echo "${v}"
    done
}

# Print every vertex in the same column as the given vertex and below it.
verts_below() {
    local vertex=$1
    local -i r c rr cc
    local v
    parse_vertex "${vertex}" r c
    for v in "${vertices[@]}"; do
        parse_vertex "${v}" rr cc
        (( c == cc && r < rr )) && echo "${v}"
    done
}

# Succeed if the four sides between the top-left and bottom-right vertices are drawn.
is_rectangle() {
    local topL=$1 bottomR=$2
    local -i r1 r2 c1 c2
    parse_vertex "${topL}"    r1 c1
    parse_vertex "${bottomR}" r2 c2

    horizontal_line "${r1}" "${c1}" "${c2}" &&
    horizontal_line "${r2}" "${c1}" "${c2}" &&
    vertical_line   "${c1}" "${r1}" "${r2}" &&
    vertical_line   "${c2}" "${r1}" "${r2}"
}

# Succeed if row $1, columns $2 to $3 contain only "-" and "+".
horizontal_line() {
    local -i row=$1 col1=$2 col2=$3
    [[ ${rows[row]:col1:col2-col1+1} == +([-+]) ]]
}

# Succeed if column $1, rows $2 to $3 contain only "|" and "+".
vertical_line() {
    local -i col=$1 row1=$2 row2=$3 r
    for ((r=row1; r<=row2; r++)); do
        [[ ${rows[r]:col:1} == @([|+]) ]] || return 1
    done
}

main
