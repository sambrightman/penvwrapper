load test_helper/helpers
load_lib bats-support
load_lib bats-assert

setup() {
    init_penvwrapper
    penv=$(random_penv_name)
    module=JSON
    namespace=Text
    namespace_module=${namespace}::CSV
}

teardown() {
    deinit_penvwrapper
}

@test "install a simple module" {
    pmkvirtualenv ${penv}
    assert_in_penv ${penv}
    cpanm --notest ${module}
    assert_module_installed ${module}
    deactivate
    assert_not_in_penv
    assert_module_not_installed ${module}
}

@test "remove a simple module" {
    pmkvirtualenv ${penv}
    assert_in_penv ${penv}
    cpanm --notest ${module}
    deactivate
    assert_not_in_penv
    pworkon ${penv}
    assert_in_penv ${penv}
    echo y | cpanm -U ${module}
    assert_module_not_installed ${module}
}

@test "change directory to a simple module" {
    pmkvirtualenv ${penv}
    assert_in_penv ${penv}
    cpanm --notest ${module}
    pcdperllib ${module}
    assert_equal "${PWD}" "${VIRTUAL_ENV}/lib/perl5/${module}"
}

@test "install a namespaced module" {
    pmkvirtualenv ${penv}
    assert_in_penv ${penv}
    cpanm --notest ${namespace_module}
    assert_module_installed ${namespace_module}
    deactivate
    assert_not_in_penv
    assert_module_not_installed ${namespace_module}
}

@test "remove a namespaced module" {
    pmkvirtualenv ${penv}
    assert_in_penv ${penv}
    cpanm --notest ${namespace_module}
    deactivate
    assert_not_in_penv
    pworkon ${penv}
    assert_in_penv ${penv}
    echo y | cpanm -U ${namespace_module}
    assert_module_not_installed ${namespace_module}
}

@test "change directory to a namespaced module" {
    pmkvirtualenv ${penv}
    assert_in_penv ${penv}
    cpanm --notest ${namespace_module}
    pcdperllib ${namespace_module}
    assert_equal "${PWD}" "${VIRTUAL_ENV}/lib/perl5/${namespace}"
}
