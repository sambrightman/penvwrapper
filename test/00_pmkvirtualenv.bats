load test_helper/helpers
load_lib bats-support
load_lib bats-assert

setup() {
    init_penvwrapper
    penv=$(random_penv_name)
}

teardown() {
    rm -rf test/pvirtualenvs
}

@test "makes a penv" {
    run pmkvirtualenv ${penv}
    assert_success
}

@test "penv exists after creation" {
    run pmkvirtualenv ${penv}
    assert_success
    run plsvirtualenv
    assert_success
    assert_output ${penv}
}

@test "penv activated after creation" {
    pmkvirtualenv ${penv}
    assert_in_penv ${penv}
}

@test "fails if no penv is given" {
    run pmkvirtualenv
    assert_failure
    assert_output --partial "You must provide a name."
    run plsvirtualenv
    assert_success
    assert_no_output
}

@test "fails if PENVWRAPPER_PENV is unset" {
    unset PENVWRAPPER_PENV
    run pmkvirtualenv ${penv}
    assert_failure
    assert_line --partial "PENVWRAPPER_PENV: You must specify a location for penv.pl."
    run plsvirtualenv
    assert_success
    assert_no_output
}

@test "fails if PWORKON_HOME is unset" {
    unset PWORKON_HOME
    run pmkvirtualenv ${penv}
    assert_failure
    assert_line --partial "PWORKON_HOME: You must specify a location for pvirtualenvs."
}
