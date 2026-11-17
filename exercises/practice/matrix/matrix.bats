#!/usr/bin/env bats
load bats-extra

# generated on 2026-11-17T10:21:05+00:00

test_extract_row_from_one_number_matrix() { # @test
    # [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash matrix.sh $'1' row 1
    assert_success
    assert_output "1"
}

test_can_extract_row() { # @test
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash matrix.sh $'1 2\n3 4' row 2
    assert_success
    assert_output "3 4"
}

test_extract_row_where_numbers_have_different_widths() { # @test
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash matrix.sh $'1 2\n10 20' row 2
    assert_success
    assert_output "10 20"
}

test_can_extract_row_from_non_square_matrix_with_no_corresponding_column() { # @test
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash matrix.sh $'1 2 3\n4 5 6\n7 8 9\n8 7 6' row 4
    assert_success
    assert_output "8 7 6"
}

test_extract_column_from_one_number_matrix() { # @test
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash matrix.sh $'1' column 1
    assert_success
    assert_output "1"
}

test_can_extract_column() { # @test
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash matrix.sh $'1 2 3\n4 5 6\n7 8 9' column 3
    assert_success
    assert_output "3 6 9"
}

test_can_extract_column_from_non_square_matrix_with_no_corresponding_row() { # @test
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash matrix.sh $'1 2 3 4\n5 6 7 8\n9 8 7 6' column 4
    assert_success
    assert_output "4 8 6"
}

test_extract_column_where_numbers_have_different_widths() { # @test
    [[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run bash matrix.sh $'89 1903 3\n18 3 1\n9 4 800' column 2
    assert_success
    assert_output "1903 3 4"
}
