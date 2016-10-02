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
    local name=$1 && shift
    "$PENVWRAPPER_PENV" "${PWORKON_HOME}/${name:?You must provide a name.}" "$@"
    pworkon "${name}"
}

pworkon() {
    local name=$1 && shift
    if [ -z "${name}" ]; then
        plsvirtualenv
    elif [ -s "${PWORKON_HOME}/${name}/bin/activate" ]; then
        # shellcheck disable=SC1090 
        . "${PWORKON_HOME:?PWORKON_HOME is not set, please set it.}/${name}/bin/activate"
    else
        echo "${name} is not a pvirtualenv" && return 1
    fi
}

plsvirtualenv() {
    local penv
    for penv in ${PWORKON_HOME}/*/; do
        if [ -d "${penv}" ]; then
            basename "$penv"
        fi
    done
}

pcdvirtualenv() {
    local name=$1 && shift
    if [ -n "${name}" ] && [ -d "${PWORKON_HOME}/${name}" ]; then
        cd "${PWORKON_HOME:?PWORKON_HOME is not set, please set it.}/${name}" || return
    elif [ -n "${VIRTUAL_ENV}" ] && [ "$(dirname "${VIRTUAL_ENV}")" = "${PWORKON_HOME}" ]; then
        cd "${VIRTUAL_ENV}" || return
    elif [ -z "${name}" ]; then
        cd "${PWORKON_HOME:?PWORKON_HOME is not set, please set it.}" || return
    else
        echo "${name} is not a pvirtualenv" && return 1
    fi
}

prmvirtualenv() {
    local name=$1 && shift
    if [ -d "${PWORKON_HOME}/${name:?Please specify an environment.}" ]; then
        rm -rf "${PWORKON_HOME:?PWORKON_HOME is not set, please set it.}/${name}"
    else
        echo "${name} is not a pvirtualenv" && return 1
    fi
}
