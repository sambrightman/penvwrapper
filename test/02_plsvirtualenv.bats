load test_helper/helpers
load_lib bats-support
load_lib bats-assert

setup() {
    init_penvwrapper
    first_penv=$(random_penv_name)
    other_penv=$(random_penv_name)
}

teardown() {
    rm -rf test/pvirtualenvs
}

@test "no output if no penvs exist" {
    run plsvirtualenv
    assert_success
    assert_no_output
}

@test "lists one penv" {
    run pmkvirtualenv ${first_penv}; assert_success

    run plsvirtualenv
    assert_success
    assert_output ${first_penv}
}

@test "lists penv if activated" {
    pmkvirtualenv ${first_penv}; assert_in_penv ${first_penv}

    run plsvirtualenv
    assert_success
    assert_output ${first_penv}
}

@test "lists multiple penvs" {
    run pmkvirtualenv ${first_penv}; assert_success
    run pmkvirtualenv ${other_penv}; assert_success

    run plsvirtualenv
    assert_success
    assert_line ${first_penv}
    assert_line ${other_penv}
}

@test "does not list invalid penvs" {
    touch "${PWORKON_HOME}/invalidpenv"
    run plsvirtualenv
    assert_success
    refute_line "invalidpenv"
}

@test "fails if PWORKON_HOME is unset" {
    unset PWORKON_HOME
    run plsvirtualenv
    assert_failure
    assert_line --partial "PWORKON_HOME: You must specify a location for pvirtualenvs."
}
