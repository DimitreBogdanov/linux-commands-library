#!/usr/bin/env bash

#Maybe change to have add as just the full command and deduce where to save it
USAGE="Usage: library show <base_command> | add <base_command> <full_command>"
APPDATA_LOCATION=~/.lib

check_directory(){
    _DIR=$1;
    if [ ! -d "$_DIR" ]; then
        mkdir "${_DIR}"
    fi
}

show_command(){
    _ROOT_COMMAND=$1;
    echo "Searching for saved '${_ROOT_COMMAND}' commands..."

    check_directory "$(echo ${APPDATA_LOCATION} | sed 's/ /\ /g')"

    if [ -f  "${APPDATA_LOCATION}/${_ROOT_COMMAND}.libr" ]; then
        COUNT=$(wc -l "${APPDATA_LOCATION}/${_ROOT_COMMAND}.libr" | awk '{print $1}')
        echo "Found ${COUNT} '${_ROOT_COMMAND}' command(s): "
        echo
        cat "${APPDATA_LOCATION}/${_ROOT_COMMAND}.libr"
    else
        echo "There are no saved '${_ROOT_COMMAND}' commands"
    fi
}

add_command(){
    _ROOT_COMMAND=$1;
    _FULL_COMMAND=$2;
    echo "Saving '${_FULL_COMMAND}'..."

    check_directory "$(echo ${APPDATA_LOCATION} | sed 's/ /\ /g')"

    if [ -f  "${APPDATA_LOCATION}/${_ROOT_COMMAND}.libr" ]; then
        echo ${_FULL_COMMAND} >> "${APPDATA_LOCATION}/${_ROOT_COMMAND}.libr"
    else
        echo ${_FULL_COMMAND} > "${APPDATA_LOCATION}/${_ROOT_COMMAND}.libr"
    fi

    echo "Done!"
}

usage_exit(){
    echo ${USAGE}
    exit
}

if [[ $# -lt 2 ]]; then
    usage_exit
fi

if [[ $1 == "show" ]] && [[ $# -eq 2 ]]; then
    show_command $2
    exit
fi

if [[ $1 == "add" ]] && [[ $# -gt 2 ]]; then
    ROOT_COMMAND=$2
    FULL_COMMAND=""
    shift 2
    #May not work properly with quotes in the command, TBD
    for var in "$@"
    do
        FULL_COMMAND="${FULL_COMMAND} ${var}"
    done
    add_command ${ROOT_COMMAND} "$(echo ${FULL_COMMAND} | sed 's/ /\ /g')"
    exit
fi

usage_exit