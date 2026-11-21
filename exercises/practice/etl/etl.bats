#!/usr/bin/env bats
load bats-extra

# generated on 2026-11-21T22:35:54+00:00

@test "single letter" {
    # [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash etl.sh "1:A"
    assert_success
    assert_line "a: 1"
    assert_equal "${#lines[@]}" 1
}

@test "single score with multiple letters" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash etl.sh "1:A,E,I,O,U"
    assert_success
    assert_line "a: 1"
    assert_line "e: 1"
    assert_line "i: 1"
    assert_line "o: 1"
    assert_line "u: 1"
    assert_equal "${#lines[@]}" 5
}

@test "multiple scores with multiple letters" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash etl.sh "1:A,E" "2:D,G"
    assert_success
    assert_line "a: 1"
    assert_line "d: 2"
    assert_line "e: 1"
    assert_line "g: 2"
    assert_equal "${#lines[@]}" 4
}

@test "multiple scores with differing numbers of letters" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash etl.sh "1:A,E,I,O,U,L,N,R,S,T" "2:D,G" "3:B,C,M,P" "4:F,H,V,W,Y" "5:K" "8:J,X" "10:Q,Z"
    assert_success
    assert_line "a: 1"
    assert_line "b: 3"
    assert_line "c: 3"
    assert_line "d: 2"
    assert_line "e: 1"
    assert_line "f: 4"
    assert_line "g: 2"
    assert_line "h: 4"
    assert_line "i: 1"
    assert_line "j: 8"
    assert_line "k: 5"
    assert_line "l: 1"
    assert_line "m: 3"
    assert_line "n: 1"
    assert_line "o: 1"
    assert_line "p: 3"
    assert_line "q: 10"
    assert_line "r: 1"
    assert_line "s: 1"
    assert_line "t: 1"
    assert_line "u: 1"
    assert_line "v: 4"
    assert_line "w: 4"
    assert_line "x: 8"
    assert_line "y: 4"
    assert_line "z: 10"
    assert_equal "${#lines[@]}" 26
}

