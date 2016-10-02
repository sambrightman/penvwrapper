# -*- mode: bash-script -*-
#
# Shell functions to act as wrapper for Joe Topjian's penv
# (https://github.com/jtopjian)
#
# You should have penv.pl in your path or set PENVWRAPPER_PENV.
#
# Copyright 2016 Sam Brightman

if [[ -z "${PWORKON_HOME}" ]]; then
    export PWORKON_HOME=~/.pvirtualenvs
fi

mkdir -p "${PWORKON_HOME}"

if [[ -z "${PENVWRAPPER_PENV}" ]]
then
    PENVWRAPPER_PENV="penv.pl"
fi

function pmkvirtualenv() {
    local name=$1 && shift
    "$PENVWRAPPER_PENV" "${PWORKON_HOME}/${name}" "$@"
    pworkon "${name}"
}

function pworkon() {
    local name=$1 && shift
    if [[ -z "${name}" ]]; then
        plsvirtualenv
    elif [ -s "${PWORKON_HOME}/${name}/bin/activate" ]; then
        source "${PWORKON_HOME:?PWORKON_HOME is not set, please set it}/${name}/bin/activate"
    else
        echo "${name} is not a pvirtualenv"
    fi
}

function plsvirtualenv() {
    local nullglob; nullglob=$(shopt -p nullglob)
    shopt -s nullglob
    for d in ${PWORKON_HOME}/*; do
        basename "$d"
    done
    $nullglob
}

function pcdvirtualenv() {
    local name=$1 && shift
    if [[ -n "${name}" && -d "${PWORKON_HOME}/${name}" ]]; then
        cd "${PWORKON_HOME:?PWORKON_HOME is not set, please set it}/${name}"
    elif [[ -n "${VIRTUAL_ENV}" && "$(dirname "${VIRTUAL_ENV}")" == "${PWORKON_HOME}" ]]; then
        cd "${VIRTUAL_ENV}"
    elif [ -z "${name}" ]; then
        cd "${PWORKON_HOME:?PWORKON_HOME is not set, please set it}"
    else
        echo "${name} is not a pvirtualenv"
    fi
}

function prmvirtualenv() {
    local name=$1 && shift
    if [ -d "${PWORKON_HOME}/${name:?Please specify an environment.}" ]; then
        rm -rf "${PWORKON_HOME:?PWORKON_HOME is not set, please set it}/${name}"
    else
        echo "${name} is not a pvirtualenv"
    fi
}
