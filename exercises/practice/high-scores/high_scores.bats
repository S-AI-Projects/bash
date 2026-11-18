#!/usr/bin/env bats
load bats-extra

# generated on 2026-11-18T18:06:08+00:00

@test "List of scores" {
    # [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh scores 30 50 20 70
    assert_success
    assert_output "30 50 20 70"
}

@test "Latest score" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh latest 100 0 90 30
    assert_success
    assert_output "30"
}

@test "Personal best" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh personalBest 40 100 70
    assert_success
    assert_output "100"
}

@test "Personal top three from a list of scores" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh personalTopThree 10 30 90 30 100 20 10 0 30 40 40 70 70
    assert_success
    assert_output "100 90 70"
}

@test "Personal top highest to lowest" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh personalTopThree 20 10 30
    assert_success
    assert_output "30 20 10"
}

@test "Personal top when there is a tie" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh personalTopThree 40 20 40 30
    assert_success
    assert_output "40 40 30"
}

@test "Personal top when there are less than 3" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh personalTopThree 30 70
    assert_success
    assert_output "70 30"
}

@test "Personal top when there is only one" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh personalTopThree 40
    assert_success
    assert_output "40"
}

@test "Latest score after personal top scores" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh personalTopThree 70 50 20 30
    run bash high_scores.sh latest 70 50 20 30
    assert_success
    assert_output "30"
}

@test "Scores after personal top scores" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh personalTopThree 30 50 20 70
    run bash high_scores.sh scores 30 50 20 70
    assert_success
    assert_output "30 50 20 70"
}

@test "Latest score after personal best" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh personalBest 20 70 15 25 30
    run bash high_scores.sh latest 20 70 15 25 30
    assert_success
    assert_output "30"
}

@test "Scores after personal best" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash high_scores.sh personalBest 20 70 15 25 30
    run bash high_scores.sh scores 20 70 15 25 30
    assert_success
    assert_output "20 70 15 25 30"
}

