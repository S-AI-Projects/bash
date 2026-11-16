#!/usr/bin/env bats
load bats-extra

# generated on 2026-11-16T18:19:15+00:00

@test "Orange, orange, black and red" {
    # [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "orange" "orange" "black" "red"
    assert_success
    assert_output "33 ohms ±2%"
}

@test "Blue, gray, brown and violet" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "blue" "grey" "brown" "violet"
    assert_success
    assert_output "680 ohms ±0.1%"
}

@test "Red, black, red and green" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "red" "black" "red" "green"
    assert_success
    assert_output "2 kiloohms ±0.5%"
}

@test "Green, brownm orange and grey" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "green" "brown" "orange" "grey"
    assert_success
    assert_output "51 kiloohms ±0.05%"
}

@test "Only one band" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "black"
    assert_success
    assert_output "0 ohms"
}

@test "Orange, orange, yellow, black and brown" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "orange" "orange" "yellow" "black" "brown"
    assert_success
    assert_output "334 ohms ±1%"
}

@test "Red, green, yellow, yellow and brown" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "red" "green" "yellow" "yellow" "brown"
    assert_success
    assert_output "2.54 megaohms ±1%"
}

@test "Blue, gray, white, brown and brown" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "blue" "grey" "white" "brown" "brown"
    assert_success
    assert_output "6.89 kiloohms ±1%"
}

@test "Violet, orange, red and gray" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "violet" "orange" "red" "grey"
    assert_success
    assert_output "7.3 kiloohms ±0.05%"
}

@test "Brown, red, orange, green and blue" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "brown" "red" "orange" "green" "blue"
    assert_success
    assert_output "12.3 megaohms ±0.25%"
}

@test "Brown, black, brown, yellow and violet" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "brown" "black" "brown" "yellow" "violet"
    assert_success
    assert_output "1.01 megaohms ±0.1%"
}

@test "Brown, black, red and red" {
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash resistor_color_tolerance.sh "brown" "black" "red" "red"
    assert_success
    assert_output "1 kiloohms ±2%"
}

