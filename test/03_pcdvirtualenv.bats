load test_helper/helpers
load_lib bats-support
load_lib bats-assert

setup() {
    PWORKON_HOME="$(realpath test/pvirtualenvs)"
    source penvwrapper.sh
    penv=$(basename "$(mktemp -u)")
    run pmkvirtualenv ${penv}
}

teardown() {
    rm -rf test/pvirtualenvs
}

@test "change directory to active penv if no penv is given" {
    pworkon ${penv}; assert_in_penv ${penv}
    pcdvirtualenv
    assert_equal "${PWD}" "${VIRTUAL_ENV}"
}

@test "change directory to PWORKON_HOME if no penv is active" {
    pcdvirtualenv
    assert_equal "${PWD}" "${PWORKON_HOME}"
}

@test "change directory to specified penv" {
    pcdvirtualenv ${penv}
    assert_equal "${PWD}" "${PWORKON_HOME}/${penv}" 
}

@test "fails if penv does not exist" {
    run pcdvirtualenv "invalidpenv"
    assert_failure
    assert_line "invalidpenv is not a pvirtualenv."
}

@test "fails if PWORKON_HOME is unset" {
    unset PWORKON_HOME
    run pcdvirtualenv ${penv}
    assert_failure
    assert_line --partial "PWORKON_HOME: You must specify a location for pvirtualenvs."
}

@test "fails if PWORKON_HOME is unset and no penv is given" {
    unset PWORKON_HOME
    run pcdvirtualenv
    assert_failure
    assert_line --partial "PWORKON_HOME: You must specify a location for pvirtualenvs."
}
