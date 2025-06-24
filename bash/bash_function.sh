#!/usr/bin/bash

# configurable parameters
DEBUG_LEVEL=2

# logging function
# $1 (string) level of the log
# $2 (string) message to log
function log_message() {
    local level="$1"
    local message="$2"
    # echo "\$0: |$0|"
    if test "-bash" = "$0"; then
        # if the script is run as a bash script, use the basename of the script
        # to get the script name.
        local script_name=$0
    else
        # if the script is run as a source, use the basename of the script
        # to get the script name.
        local script_name=$(basename -a "$0")
    fi
    # local script_name="test1"
    echo "[$script_name $level] $message"
}

# dedug print only when the debug flag is greater than DEBUG_LEVEL.
# $1 (int) debug flag
# ${@:2} (string) message
function debugp() {
    if [ "$1" -ge "$DEBUG_LEVEL" ]; then
        log_message "DEBUG ${@:2}\n"
    fi
}

# info print
# $@ (string) message
function infop() {
    log_message "INFO" "$@"
}

# error print
# $@ (string) message
function errorp() {
    log_message "ERROR" "$@"
}

# check if the source file exists and source it
# $1 (string) source file path
function check_source {
    local sourcefile="$1"
    debugp 1 "$sourcefile"

    if test -f "$sourcefile"; then
        source "$sourcefile"
        infop "source $sourcefile"
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

function pjr {
    echo "$(git rev-parse --show-toplevel)"
}

# symlink the file to the destination directory
# if the file exists, do not symlink
# $1: source file
# $2: destination directory
# $3: destination filename
# Ex: symlink .bashrc ${HOME} .bash
function symlink() {
    # don't symlink if the file exists
    local filename=$(basename $1)

    # if the 3rd argument is not empty, use it as the filename
    if [ ! -z "$3" ]; then
        filename="$3"
    fi

    local dst_file_path="$2/$filename"
    if [ -f "$dst_file_path" ]; then
        echo "${LABEL} skipping ${dst_file_path} exists"
        return 0
    fi

    echo "${LABEL} symlink ${1} ${2}/$filename"
    ln -sf $(pwd)/$1 $dst_file_path
}

# symlink the file to the destination directory
# if the file exists, do not symlink
# $1: source file
# $2: destination directory
# $3: destination filename
# Ex: symlink .bashrc ${HOME}
function symlink_force() {
    # don't symlink if the file exists
    local filename=$(basename $1)

    # if the 3rd argument is not empty, use it as the filename
    if [ ! -z "$3" ]; then
        filename="$3"
    fi

    local dst_file_path="$2/$filename"
    echo "${LABEL} symlink ${1} ${2}/$filename"
    ln -sf $(pwd)/$1 $dst_file_path
}
