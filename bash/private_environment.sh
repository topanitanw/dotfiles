# private environment variable for the local machine

. ~/.shell_files/bash_function.sh

USERNAME=$(whoami)

if [ -z "${ORIGINAL_PATH}" ]; then
    export ORIGINAL_PATH=${PATH}
else
    PATH=${ORIGINAL_PATH}
fi

## anaconda python
export PATH="/home/${USERNAME}/anaconda3/bin:${PATH}"

## pin
export PIN_ROOT="/home/${USERNAME}/Work/research/software/intel_pin/v3.7"
unset PIN_ROOT

## parsec
export PARSECDIR="/home/${USERNAME}/Work/research/software/parsec-3.0"
export PARSECBIN="/home/${USERNAME}/Work/research/software/parsec-3.0/bin"
export PATH=${PARSECBIN}:"$PATH"

## git
# a solution to push to the github
# unset SSH_ASKPASS
