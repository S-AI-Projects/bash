#!/usr/bin/env bash

buildTree() {
    local -a preorder inorder
    
    # read the space-separated items into an array
    read -ra preorder <<< "${1}"
    read -ra inorder  <<< "${2}"

    validate preorder inorder

    if (( ${#preorder[@]} == 0 )); then
        echo "{}"
        return
    fi

    local root="${preorder[0]}"
    local -i idx
    idx=$( indexOf "${root}" "${inorder[@]}" )
    (( idx == -1 )) && die "should not happen"

    local -a leftInorder=( "${inorder[@]:0:${idx}}" )
    local -a rightInorder=( "${inorder[@]:${idx} + 1}" )

    local -a leftPreorder=( "${preorder[@]:1:${idx}}" )
    local -a rightPreorder=( "${preorder[@]:${idx} + 1}" )

    local left_tree right_tree
    left_tree=$( buildTree "${leftPreorder[*]}" "${leftInorder[*]}" )
    right_tree=$( buildTree "${rightPreorder[*]}" "${rightInorder[*]}" )

    printf '{"v": "%s", "l": %s, "r": %s}' \
        "${root}" \
        "${left_tree}" \
        "${right_tree}"
}

validate() {
    local -n _preorder="${1}"  _inorder="${2}"

    if (( ${#_preorder[@]} != ${#_inorder[@]} )); then
        die "Traversals must have the same length"
    fi

    local -A seen=()
    local elem
    local -i elem_idx

    for elem in "${_preorder[@]}"; do
        if [[ -n "${seen["${elem}"]:-}" ]]; then
            die "Traversals must contain unique items"
        fi
        seen["${elem}"]=1
        elem_idx=$( indexOf "${elem}" "${_inorder[@]}" )
        if (( elem_idx == -1 )); then
            die "Traversals must have the same elements"
        fi
    done
}

indexOf() {
    local needle="${1}"
    local -a haystack=( "${@:2}" )
    local -i i

    for (( i=0; i < ${#haystack[@]}; i++ )); do
        if [[ "${needle}" == "${haystack[i]}" ]]; then
            echo "${i}"
            return
        fi
    done

    echo "-1"   # not found
}

die() { echo "${*}" >&2; exit 1; }

buildTree "${@}"
