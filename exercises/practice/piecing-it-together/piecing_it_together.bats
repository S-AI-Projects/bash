#!/usr/bin/env bats
load bats-extra

# generated on 2026-11-18T13:52:17+00:00

@test "1000 pieces puzzle with 1.6 aspect ratio" {
    # [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash piecing_it_together.sh pieces=1000 aspectRatio=1.6
    expectedJson=$(cat << END_JSON
    {
        "pieces": 1000,
        "border": 126,
        "inside": 874,
        "rows": 25,
        "columns": 40,
        "aspectRatio": 1.6,
        "format": "landscape"
    }
END_JSON
)
    # compare without spaces
    [[ "${output//[[:space:]]/}" == "${expectedJson//[[:space:]]/}" ]]
}
@test "square puzzle with 32 rows" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash piecing_it_together.sh rows=32 format=square
    expectedJson=$(cat << END_JSON
    {
        "pieces": 1024,
        "border": 124,
        "inside": 900,
        "rows": 32,
        "columns": 32,
        "aspectRatio": 1.0,
        "format": "square"
    }
END_JSON
)
    # compare without spaces
    [[ "${output//[[:space:]]/}" == "${expectedJson//[[:space:]]/}" ]]
}
@test "400 pieces square puzzle with only inside pieces and aspect ratio" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash piecing_it_together.sh inside=324 aspectRatio=1.0
    expectedJson=$(cat << END_JSON
    {
        "pieces": 400,
        "border": 76,
        "inside": 324,
        "rows": 20,
        "columns": 20,
        "aspectRatio": 1.0,
        "format": "square"
    }
END_JSON
)
    # compare without spaces
    [[ "${output//[[:space:]]/}" == "${expectedJson//[[:space:]]/}" ]]
}
@test "300 pieces portrait puzzle with 70 border pieces" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash piecing_it_together.sh pieces=300 border=70 format=portrait
    expectedJson=$(cat << END_JSON
    {
        "pieces": 300,
        "border": 70,
        "inside": 230,
        "rows": 25,
        "columns": 12,
        "aspectRatio": 0.48,
        "format": "portrait"
    }
END_JSON
)
    # compare without spaces
    [[ "${output//[[:space:]]/}" == "${expectedJson//[[:space:]]/}" ]]
}
@test "puzzle with insufficient data" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash piecing_it_together.sh pieces=1500 format=landscape
    assert_failure
    assert_output --partial "Insufficient data"
}
@test "puzzle with contradictory data" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash piecing_it_together.sh rows=100 columns=1000 format=square
    assert_failure
    assert_output --partial "Contradictory data"
}
