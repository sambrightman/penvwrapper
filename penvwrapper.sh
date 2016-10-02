# shellcheck disable=SC2039

# Shell functions to act as wrapper for Joe Topjian's penv
# (https://github.com/jtopjian)
#
# You should have penv.pl in your path or set PENVWRAPPER_PENV.
#
# Copyright 2016 Sam Brightman

if [ -z "${PWORKON_HOME}" ]; then
    export PWORKON_HOME=~/.pvirtualenvs
fi

mkdir -p "${PWORKON_HOME}"

if [ -z "${PENVWRAPPER_PENV}" ]
then
    PENVWRAPPER_PENV="penv.pl"
fi

pmkvirtualenv() {
    local name=${1:?You must provide a name.}
    "${PENVWRAPPER_PENV:?You must specify a location for penv.pl.}" "${PWORKON_HOME:?You must specify a location for pvirtualenvs.}/${name}" "$@"
    pworkon "${name}"
}

pworkon() {
    local name=$1
    if [ -z "${name}" ]; then
        plsvirtualenv
    elif [ -d "${PWORKON_HOME:?You must specify a location for pvirtualenvs.}/${name}" ]; then
        if [ -s "${PWORKON_HOME}/${name}/bin/activate" ]; then
            # shellcheck disable=SC1090
            . "${PWORKON_HOME}/${name}/bin/activate"
        else
            echo "${name} is corrupted." && return 1
        fi
    else
        echo "${name} is not a pvirtualenv." && return 1
    fi
}

plsvirtualenv() {
    local penv
    for penv in ${PWORKON_HOME:?You must specify a location for pvirtualenvs.}/*/; do
        if [ -d "${penv}" ]; then
            basename "${penv}"
        fi
    done
}

pcdvirtualenv() {
    local name=$1
    if [ -n "${name:-}" ] && [ -d "${PWORKON_HOME:?You must specify a location for pvirtualenvs.}/${name}" ]; then
        cd "${PWORKON_HOME}/${name}" || return
    elif [ -n "${VIRTUAL_ENV}" ] && [ "$(dirname "${VIRTUAL_ENV}")" = "${PWORKON_HOME}" ]; then
        cd "${VIRTUAL_ENV}" || return
    elif [ -z "${name}" ]; then
        cd "${PWORKON_HOME:?You must specify a location for pvirtualenvs.}" || return
    else
        echo "${name} is not a pvirtualenv." && return 1
    fi
}

prmvirtualenv() {
    local name=${1:?You must specify an environment.}
    if [ -d "${PWORKON_HOME:?You must specify a location for pvirtualenvs.}/${name}" ]; then
        rm -rf "${PWORKON_HOME:?You must specify a location for pvirtualenvs.}/${name}"
    else
        echo "${name} is not a pvirtualenv." && return 1
    fi
}
