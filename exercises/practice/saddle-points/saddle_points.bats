#!/usr/bin/env bats
load bats-extra

# generated on 2026-11-23T15:14:23+00:00


@test "Can identify single saddle point" {
    # [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash saddle_points.sh "9 8 7" "5 3 2" "6 6 7"
    assert_success
    expected=$(cat <<'EXPECTED'
row 2, column 1
EXPECTED
)
    assert_output "$expected"
}

@test "Can identify that empty matrix has no saddle points" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash saddle_points.sh
    assert_success
    assert_output ""
}

@test "Can identify lack of saddle points when there are none" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash saddle_points.sh "1 2 3" "3 1 2" "2 3 1"
    assert_success
    assert_output ""
}

@test "Can identify multiple saddle points in a column" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash saddle_points.sh "4 5 4" "3 5 5" "1 5 4"
    assert_success
    expected=$(cat <<'EXPECTED'
row 1, column 2
row 2, column 2
row 3, column 2
EXPECTED
)
    assert_output "$expected"
}

@test "Can identify multiple saddle points in a row" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash saddle_points.sh "6 7 8" "5 5 5" "7 5 6"
    assert_success
    expected=$(cat <<'EXPECTED'
row 2, column 1
row 2, column 2
row 2, column 3
EXPECTED
)
    assert_output "$expected"
}

@test "Can identify saddle point in bottom right corner" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash saddle_points.sh "8 7 9" "6 7 6" "3 2 5"
    assert_success
    expected=$(cat <<'EXPECTED'
row 3, column 3
EXPECTED
)
    assert_output "$expected"
}

@test "Can identify saddle points in a non square matrix" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash saddle_points.sh "3 1 3" "3 2 4"
    assert_success
    expected=$(cat <<'EXPECTED'
row 1, column 1
row 1, column 3
EXPECTED
)
    assert_output "$expected"
}

@test "Can identify that saddle points in a single column matrix are those with the minimum value" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash saddle_points.sh "2" "1" "4" "1"
    assert_success
    expected=$(cat <<'EXPECTED'
row 2, column 1
row 4, column 1
EXPECTED
)
    assert_output "$expected"
}

@test "Can identify that saddle points in a single row matrix are those with the maximum value" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash saddle_points.sh "2 5 3 5"
    assert_success
    expected=$(cat <<'EXPECTED'
row 1, column 2
row 1, column 4
EXPECTED
)
    assert_output "$expected"
}

