load test_helper/helpers
load_lib bats-support
load_lib bats-assert

setup() {
    init_penvwrapper
    penv=$(random_penv_name)
    pmkvirtualenv ${penv}
    deactivate
}

teardown() {
    deinit_penvwrapper
}

@test "lists some modules" {
    pworkon ${penv}
    run plsperllib
    assert_success
    perl_arch=$(perl -MConfig -e 'print $Config{archname}')
    perl_version=$(perl -MConfig -e 'print $Config{version}')
    assert_line $perl_arch
    assert_line $perl_version
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
