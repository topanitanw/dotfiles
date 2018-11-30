#!/bin/bash

LABEL="[INSTALL]"
DST_DIR="${HOME}"
printf "${LABEL} home directory: ${DST_DIR}\n"

function fsync {
    # check if the file exists
    if [ ! -f $1 ]; then
        return 0
    fi

    printf "${LABEL} ${1} ${2}\n"
    rsync $1 $2
}

fsync emacs/.emacs "${DST_DIR}"
fsync vim/.vimrc "${DST_DIR}"
fsync bash/.bashrc "${DST_DIR}"
fsync bash/.bash_profile "${DST_DIR}"
fsync bash/.inputrc "${DST_DIR}"

SHELLFILES_DIR="${DST_DIR}/.shell_files"
mkdir -p "${SHELLFILES_DIR}"
fsync bash/alias_command.bash "${SHELLFILES_DIR}"

fsync .tmux.conf "${DST_DIR}"
fsync .pylintrc "${DST_DIR}"

##################################################
# nvim config
CONFIG_DIR="${DST_DIR}/.config"
mkdir -p "${CONFIG_DIR}"

NVIM_DIR="${CONFIG_DIR}/nvim"
mkdir -p "${NVIM_DIR}"

fsync vim/init.vim "${NVIM_DIR}"

##################################################
# jupyter notebook
JUPYTERNB_DIR="${DST_DIR}/.jupyter"
mkdir -p "${JUPYTERNB_DIR}"

JUPYTERNBCONFIG_DIR="${DST_DIR}/.jupyter/nbconfig/"
mkdir -p "${JUPYTERNBCONFIG_DIR}"

fsync jupyter/notebook.json "${JUPYTERNB_DIR}"
##################################################

printf "${LABEL} done\n"

