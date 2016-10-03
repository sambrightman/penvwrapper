load test_helper/helpers
load_lib bats-support
load_lib bats-assert

setup() {
    init_penvwrapper
    first_penv=$(random_penv_name)
    other_penv=$(random_penv_name)
    pmkvirtualenv ${first_penv}
    pmkvirtualenv ${other_penv}
}

teardown() {
    deinit_penvwrapper
}

@test "workon a penv" {
    pworkon ${first_penv}
    assert_in_penv ${first_penv}
}

@test "deactivates a penv" {
    pworkon ${first_penv}
    assert_in_penv ${first_penv}
    deactivate
    assert_not_in_penv
}

@test "switches penvs" {
    pworkon ${first_penv}
    assert_in_penv ${first_penv}
    pworkon ${other_penv}
    assert_in_penv ${other_penv}
}

@test "lists penvs if no penv is given" {
    run pworkon
    assert_success
    assert_line ${first_penv}
    assert_line ${other_penv}
}

@test "fails if penv does not exist" {
    run pworkon "invalidpenv"
    assert_failure
    assert_line "invalidpenv is not a pvirtualenv."
}

@test "fails if activate is missing" {
    rm -f "${PWORKON_HOME}/${first_penv}/bin/activate"
    run pworkon ${first_penv}
    assert_failure
    assert_line "${first_penv} is corrupted."
}

@test "fails if PWORKON_HOME is unset" {
    unset PWORKON_HOME
    run pworkon ${first_penv}
    assert_failure
    assert_line --partial "PWORKON_HOME: You must specify a location for pvirtualenvs."
}

@test "does not deactivate due to failure" {
    pworkon ${first_penv}
    assert_in_penv ${first_penv}
    pworkon "invalidpenv" || true 
    assert_in_penv ${first_penv}
}
