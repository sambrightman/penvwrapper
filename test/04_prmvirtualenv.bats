load test_helper/helpers
load_lib bats-support
load_lib bats-assert
load_lib bats-file

setup() {
    init_penvwrapper
    first_penv=$(random_penv_name)
    other_penv=$(random_penv_name)
    pmkvirtualenv ${first_penv}
    pmkvirtualenv ${other_penv}
}

teardown() {
    rm -rf test/pvirtualenvs
}

@test "removes a penv" {
    run prmvirtualenv ${first_penv}
    assert_success
}

@test "penv does not exist after removal" {
    run prmvirtualenv ${first_penv}
    assert_success
    run plsvirtualenv
    assert_success
    refute_line ${first_penv}
}

@test "does not remove another penv" {
    run prmvirtualenv ${first_penv}
    assert_success
    run plsvirtualenv
    assert_success
    assert_line ${other_penv}
}

@test "deactivate works after removing active penv" {
    pworkon ${first_penv}
    assert_in_penv ${first_penv}
    run prmvirtualenv ${first_penv}
    assert_success
    run plsvirtualenv
    assert_success
    refute_line ${first_penv}
    deactivate
    assert_not_in_penv
}

@test "fails if no penv is given" {
    run prmvirtualenv
    assert_failure
    assert_output --partial "You must specify an environment."
    assert_file_exist "$PWORKON_HOME"
}

@test "fails if empty penv is given" {
    run prmvirtualenv ""
    assert_failure
    assert_output --partial "You must specify an environment."
    assert_file_exist "$PWORKON_HOME"
}

@test "fails if penv does not exist" {
    run prmvirtualenv "invalidpenv"
    assert_failure
    assert_line "invalidpenv is not a pvirtualenv."
    assert_file_exist "$PWORKON_HOME"
}

@test "fails if PWORKON_HOME is unset" {
    local pvirtualenv_dir="$PWORKON_HOME"
    unset PWORKON_HOME
    run prmvirtualenv ${first_penv}
    assert_failure
    assert_line --partial "PWORKON_HOME: You must specify a location for pvirtualenvs."
    assert_file_exist "$pvirtualenv_dir"
}
