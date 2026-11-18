#!/usr/bin/env bash
#
# Manage a game player's high score list.

set -o errexit
set -o nounset

#######################################
# Return the full list of scores in original order.
# Arguments:
#   Array of scores
# Outputs:
#   Space-separated list of scores
#######################################
scores() {
  echo "${*}"
}

#######################################
# Return the last added score.
# Arguments:
#   Array of scores
# Outputs:
#   Latest score
#######################################
latest() {
  local -a list=( "${@}" )
  if (( ${#list[@]} == 0 )); then
    return 0
  fi
  echo "${list[-1]}"
}

#######################################
# Return the highest score from the list.
# Arguments:
#   Array of scores
# Outputs:
#   Personal best score
#######################################
personal_best() {
  local -a list=( "${@}" )
  if (( ${#list[@]} == 0 )); then
    return 0
  fi
  local -i max="${list[0]}" score
  for score in "${list[@]}"; do
    if (( score > max )); then
      max="${score}"
    fi
  done
  echo "${max}"
}

#######################################
# Return up to three highest scores in descending order.
# Arguments:
#   Array of scores
# Outputs:
#   Space-separated top three scores
#######################################
personal_top_three() {
  local -a list=( "${@}" )
  if (( ${#list[@]} == 0 )); then
    return 0
  fi
  local -a sorted=()
  local -i i score
  for score in "${list[@]}"; do
    for (( i = 0; i < ${#sorted[@]}; i++ )); do
      if (( score > sorted[i] )); then
        break
      fi
    done
    sorted=( "${sorted[@]:0:i}" "${score}" "${sorted[@]:i}" )
  done
  local -a top3=( "${sorted[@]:0:3}" )
  echo "${top3[*]}"
}

#######################################
# Main entrypoint parsing command and scores.
# Arguments:
#   Command followed by list of scores
# Outputs:
#   Command output or error message
#######################################
main() {
  local command="${1:-}"
  shift || true

  local -a scores=( "${@}" )
  if (( ${#scores[@]} == 1 )) && [[ ${scores[0]} =~ [[:space:]] ]]; then
    read -ra scores <<< "${scores[0]}"
  fi

  case "${command}" in
    scores|scoresAfter*|scores_after_*)
      scores "${scores[@]}"
      ;;
    latest|latestAfter*|latest_after_*)
      latest "${scores[@]}"
      ;;
    personalBest|personal_best|personal-best)
      personal_best "${scores[@]}"
      ;;
    personalTopThree|personal_top_three|personal-top-three)
      personal_top_three "${scores[@]}"
      ;;
    *)
      echo "Unknown command: ${command}" >&2
      return 1
      ;;
  esac
}

main "${@}"
