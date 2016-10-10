load test_helper/helpers
load_lib bats-support
load_lib bats-assert

setup() {
    init_penvwrapper
    penv=$(random_penv_name)
    module=JSON
}

teardown() {
    deinit_penvwrapper
}

@test "install a module" {
    skip "cpanm hangs"
    pmkvirtualenv ${penv}
    assert_in_penv ${penv}
    run cpanm --quiet --notest ${module}
    assert_success
    assert_module_installed ${module}
    deactivate
    assert_not_in_penv
    assert_module_not_installed ${module}
}

@test "remove a module" {
    skip "cpanm hangs"
    pmkvirtualenv ${penv}
    assert_in_penv ${penv}
    run cpanm --quiet --notest ${module}
    assert_success
    assert_success
    deactivate
    assert_not_in_penv
    pworkon ${penv}
    assert_in_penv ${penv}
    cpanm -U ${module}
    assert_module_not_installed ${module}
}
