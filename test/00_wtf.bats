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

@test "wtf" {
    pworkon ${penv}
    assert_in_penv ${penv}
    run plsperllib
    assert_success
    assert [ -n "$output" ]
}
