load_lib() {
    local name="$1"
    load "test_helper/${name}/load"
}

init_penvwrapper() {
    PWORKON_HOME="$(pwd)/test/pvirtualenvs"
    source penvwrapper.sh
}

deinit_penvwrapper() {
    rm -rf "$(pwd)/test/pvirtualenvs"
}

random_penv_name() {
    basename "$(mktemp -u penv.XXXXXXXXXX)"
}

assert_no_output() {
    assert_output ""
}

assert_in_penv() {
    assert_equal "${VIRTUAL_ENV}" "${PWORKON_HOME}/$1"
}

assert_not_in_penv() {
    assert_equal "${VIRTUAL_ENV}" ""
}
