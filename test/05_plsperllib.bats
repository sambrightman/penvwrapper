load test_helper/helpers
load_lib bats-support
load_lib bats-assert

setup() {
    init_penvwrapper
    penv=$(random_penv_name)
    run pmkvirtualenv ${penv}
}

teardown() {
    deinit_penvwrapper
}

@test "lists some modules" {
    # maybe call cpan here and test the package is installed?
    pworkon ${penv}
    run plsperllib
    assert_success
    assert [ -n "$output" ]
}

@test "fails if directory missing" {
    pworkon ${penv}
    rm -rf "${VIRTUAL_ENV:?pworkon was successful but VIRTUAL_ENV is not set}/lib/perl5"
    run plsperllib
    assert_failure
    assert_output "${penv} is corrupted."
}

@test "fails if no penv is active" {
    run plsperllib
    assert_failure
    assert_line --partial "VIRTUAL_ENV: No pvirtualenv is active."
}
