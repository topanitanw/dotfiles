# private environment variable for the local machine

echo "reading private_environment.sh"

. ${HOME}/.shell_files/bash_function.sh

USERNAME=$(whoami)

if [ -z "${ORIGINAL_PATH}" ]; then
    export ORIGINAL_PATH=${PATH}
else
    PATH=${ORIGINAL_PATH}
fi

if [ -z "${ORIGINAL_LD_LIBRARY_PATH}" ]; then
    export ORIGINAL_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
else
    LD_LIBRARY_PATH=${ORIGINAL_LD_LIBRARY_PATH}
fi

## anaconda python
# prepend_variable PATH "${HOME}/anaconda3/bin"

## pin
# export PIN_ROOT="${HOME}/Work/research/software/intel_pin/v3.7"
# unset PIN_ROOT

## parsec
# export PARSECDIR="${HOME}/Work/research/software/parsec-3.0"
# hexport PARSECBIN="${HOME}/Work/research/software/parsec-3.0/bin"
# prepend_variable PATH "${PARSECBIN}"

# examples of the installed local library
# prepend_variable PATH "${HOME}/local/bin"
# prepend_variable LD_LIBRARY_PATH "${HOME}/local"
# prepend_variable LD_LIBRARY_PATH "${HOME}/local/lib"
# prepend_variable LD_LIBRARY_PATH "${HOME}/local/lib64"

## git
# a solution to push to the github
# unset SSH_ASKPASS

# autojump setup
if [ "$(uname)" ==  "Darwin" ]; then
    AUTOJUMP_SH="/usr/local/etc/profile.d/autojump.sh"

    if ! test -f $AUTOJUMP_SH; then
        AUTOJUMP_SH="/opt/homebrew/etc/profile.d/autojump.sh"
    fi
fi

if [ "$(uname)" == "Linux" ]; then
    AUTOJUMP_SH="${HOME}/.autojump/etc/profile.d/autojump.sh"
fi

[ -f ${AUTOJUMP_SH} ] && . ${AUTOJUMP_SH}
