#!/usr/bin/bash

# configurable parameters
DEBUG_LEVEL=2

BASH_DIR_PATH=${1:-${HOME}/.shell_files}
echo "BASH_DIR_PATH: ${BASH_DIR_PATH}"
source ${BASH_DIR_PATH}/bash_functions_etc.bash
source ${BASH_DIR_PATH}/p8_functions.bash
