#!/usr/bin/bash

# configurable parameters
DEBUG_LEVEL=1

# dedug print only when the debug flag is greater than DEBUG_LEVEL.
# $1 (int) debug flag
# ${@:2} (string) message
function debugp() {
    if [ "$DEBUG_LEVEL" -ge "$1" ]; then
    │   printf "[DEBUG] ${@:2}\n"
    fi
}

# info print
# $@ (string) message
function infop() {
    printf "[INFO] $@\n"
}

# error print
# $@ (string) message
function errorp() {
    printf "[ERROR] $@\n"
}

function check_source {
    local sourcefile="sourcefile"
    if [ -f "sourcefile{1}" ]; then
        source "$sourcefile"
        printf "source $sourcefile\n"
    else
        errorp "no $sourcefile"
    fi
}

function save_variable {
    # save_variable variable
    local var=$1
    local ovar="ORIGINAL_$var"
    if [ -z "${ovar}" ]; then
        export "${ovar}=${!var}"
    else
        export "${var}=${!ovar}"
    fi
}

function prepend_variable {
    # prepend_variable variable new_path
    local variable="$1"
    local path="$2"

    # printf "path = $path\n"
    # printf "variable = $variable\n"
    # printf "variable = ${!variable}\n"
    # should check if there is a file or directory in that path.

    if [ -d "$path" ] && [[ ":${!variable}:" != *":${path}:"* ]]; then
        # ${variable:+value} means check whether variable is defined
        # and has a non-empty value, and if it does gives the result
        # of evaluating value. Basically, if PATH is nonblank
        # to begin with it sets it to "$1:$PATH"; if it's blank it
        # sets it to just "$1" (note the lack of a colon).
        # PATH="$1${PATH:+":$PATH"}"
        local cmd=${variable}="$path${!variable:+":${!variable}"}"
        eval "export $cmd"
        # printf "cmd = $cmd\n"
    fi
    # export PATH
    # printf "variable = $variable\n"
    # printf "variable value = ${!variable}\n"
}

function remove_window_newline {
    sed -i 's/$//' $1
}
