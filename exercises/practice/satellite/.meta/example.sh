#!/usr/bin/env bash
#
# Satellite
# Reconstruct a binary tree from its preorder and inorder traversals.

#######################################
# Print an error message to STDERR and exit with code 1.
# Arguments:
#   Error message string(s)
# Outputs:
#   Writes error message to STDERR
#######################################
die() {
  echo "${*}" >&2
  exit 1
}

#######################################
# Find the 0-based index of a needle element in a haystack array.
# Arguments:
#   Needle string
#   Haystack array elements
# Outputs:
#   Index of needle if found, else -1
#######################################
indexOf() {
  local needle="${1}"
  local -a haystack=( "${@:2}" )
  local -i i

  for (( i = 0; i < ${#haystack[@]}; i++ )); do
    if [[ "${needle}" == "${haystack[i]}" ]]; then
      echo "${i}"
      return
    fi
  done

  echo "-1"
}

#######################################
# Validate preorder and inorder traversals for consistency.
# Arguments:
#   Name of preorder array variable (nameref)
#   Name of inorder array variable (nameref)
#######################################
validate() {
  local -n _preorder="${1}"
  local -n _inorder="${2}"

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
    elem_idx=$(indexOf "${elem}" "${_inorder[@]}")
    if (( elem_idx == -1 )); then
      die "Traversals must have the same elements"
    fi
  done
}

#######################################
# Reconstruct a binary tree from preorder and inorder traversals.
# Arguments:
#   Preorder traversal string (space-separated items)
#   Inorder traversal string (space-separated items)
# Outputs:
#   JSON string representation of the binary tree
#######################################
buildTree() {
  local -a preorder inorder

  # Read the space-separated items into an array
  read -ra preorder <<< "${1}"
  read -ra inorder  <<< "${2}"

  validate preorder inorder

  if (( ${#preorder[@]} == 0 )); then
    echo "{}"
    return
  fi

  local root="${preorder[0]}"
  local -i idx
  idx=$(indexOf "${root}" "${inorder[@]}")
  (( idx == -1 )) && die "should not happen"

  local -a leftInorder=( "${inorder[@]:0:${idx}}" )
  local -a rightInorder=( "${inorder[@]:${idx} + 1}" )

  local -a leftPreorder=( "${preorder[@]:1:${idx}}" )
  local -a rightPreorder=( "${preorder[@]:${idx} + 1}" )

  local left_tree right_tree
  left_tree=$(buildTree "${leftPreorder[*]}" "${leftInorder[*]}")
  right_tree=$(buildTree "${rightPreorder[*]}" "${rightInorder[*]}")

  printf '{"v": "%s", "l": %s, "r": %s}' \
    "${root}" \
    "${left_tree}" \
    "${right_tree}"
}

#######################################
# Main script entrypoint.
# Arguments:
#   Preorder traversal string
#   Inorder traversal string
#######################################
main() {
  buildTree "${@}"
}

main "${@}"
