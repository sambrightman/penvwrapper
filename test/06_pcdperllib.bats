load test_helper/helpers
load_lib bats-support
load_lib bats-assert

setup() {
    init_penvwrapper
    penv=$(random_penv_name)
    pmkvirtualenv ${penv}
    module="FakeModule"
    submodule="SubModule"
    subsubmodule="SubSubModule"
    namespace_module="${module}::${submodule}::${subsubmodule}"
    mkdir -p "${VIRTUAL_ENV}/lib/perl5/${module}/${submodule}"
    touch "${VIRTUAL_ENV}/lib/perl5/${module}/${submodule}/${subsubmodule}.pm"
    deactivate
}

teardown() {
    deinit_penvwrapper
}

@test "change directory to lib directory" {
    pworkon ${penv}
    pcdperllib
    assert_equal "${PWD}" "${VIRTUAL_ENV}/lib/perl5"
}

@test "change directory to module" {
    pworkon ${penv}
    pcdperllib ${module}
    assert_equal "${PWD}" "${VIRTUAL_ENV}/lib/perl5/${module}"
}

@test "change directory to namespaced module" {
    pworkon ${penv}
    pcdperllib ${namespace_module}
    assert_equal "${PWD}" "${VIRTUAL_ENV}/lib/perl5/${module}/${submodule}"
}

@test "warns if module does not exist" {
    pworkon ${penv}
    run pcdperllib "invalidmodule"
    assert_success
    assert_line "invalidmodule is not installed in current pvirtualenv ${penv}."
}

@test "falls back to lib root if module does not exist" {
    pworkon ${penv}
    pcdperllib "invalidmodule"
    assert_equal "${PWD}" "${VIRTUAL_ENV}/lib/perl5"
}

@test "fails if no penv is active" {
    run pcdperllib
    assert_failure
    assert_line --partial "VIRTUAL_ENV: No pvirtualenv is active."
}

@test "fails if lib directory is missing" {
    pworkon ${penv}
    rm -rf "${VIRTUAL_ENV:?pworkon was successful but VIRTUAL_ENV is not set}/lib/perl5"
    run pcdperllib
    assert_failure
    assert_output "${penv} is corrupted."
}
