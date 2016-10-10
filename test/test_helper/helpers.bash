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
    local expected
    expected="${PWORKON_HOME}/$1"
    assert_equal "${VIRTUAL_ENV}" "${expected}"
    assert_path_contains "${PATH}" "${expected}/bin"
    assert_path_contains "${PERL5LIB}" "${expected}/lib/perl5"
    assert_path_contains "${PERL_LOCAL_LIB_ROOT}" "${expected}"
    assert_equal "${PERL_MB_OPT}" "--install_base \"${expected}\""
    assert_equal "${PERL_MM_OPT}" "INSTALL_BASE=${expected}"
}

assert_not_in_penv() {
    local expected
    expected="${PWORKON_HOME}/$1"
    assert_equal "${VIRTUAL_ENV}" ""
    assert_path_not_contains "${PATH}" "${expected}/bin"
    assert_path_not_contains "${PERL5LIB}" "${expected}/lib/perl5"
    assert_path_not_contains "${PERL_LOCAL_LIB_ROOT}" "${expected}"
    # FIXME: penv.pl needs updating to unset this
    # assert_equal "${PERL_MB_OPT}" ""
    assert_equal "${PERL_MM_OPT}" ""
}

assert_path_not_contains() {
    refute bash -c "[[ \"$1\" =~ ^([^:]*:)*$2(:[^:]*)*$ ]]"
}

assert_path_contains() {
    assert bash -c "[[ \"$1\" =~ ^([^:]*:)*$2(:[^:]*)*$ ]]"
}

assert_module_installed() {
    run plsperllib
    assert_success
    assert_line $1
    run perl -M$1
    assert_success
}

assert_module_not_installed() {
    run plsperllib
    assert_success
    refute_line "$1"
    run perl -M$1
    assert_failure
    assert_line --partial "Can't locate ${1//::/\/}.pm in @INC"
}
