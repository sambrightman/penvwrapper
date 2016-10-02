load_lib() {
    local name="$1"
    load "test_helper/${name}/load"
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
