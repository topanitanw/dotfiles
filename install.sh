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

function cp_template {
    # check if the file exists, do not copy.
    if [ -f $2 ]; then
        return 0
    fi

    printf "${LABEL} ${1} ${2}\n"
    rsync $1 $2
}


##################################################
# text editor
fsync emacs/.emacs "${DST_DIR}"
fsync vim/.vimrc "${DST_DIR}"

##################################################
# nvim config
CONFIG_DIR="${DST_DIR}/.config"
mkdir -p "${CONFIG_DIR}"

NVIM_DIR="${CONFIG_DIR}/nvim"
mkdir -p "${NVIM_DIR}"

fsync vim/init.vim "${NVIM_DIR}"

##################################################
# bash shell file
# fsync bash/.bashrc "${DST_DIR}"
# fsync bash/.bash_profile "${DST_DIR}"
# fsync bash/.inputrc "${DST_DIR}"

fsync bash/.bashrc "${DST_DIR}"
SHELLFILES_DIR="${DST_DIR}/.shell_files"
mkdir -p "${SHELLFILES_DIR}"

cp_template bash/alias_command.sh \
    "${SHELLFILES_DIR}"/alias_command.sh

cp_template bash/private_environment.sh \
    "${SHELLFILES_DIR}"/private_environment.sh

fsync bash/bash_function.sh ${SHELLFILES_DIR}/bash_function.sh

# shell file
##################################################
# etc
fsync .tmux.conf "${DST_DIR}"
fsync .pylintrc "${DST_DIR}"

##################################################
# jupyter notebook
JUPYTERNB_DIR="${DST_DIR}/.jupyter"
mkdir -p "${JUPYTERNB_DIR}"

JUPYTERNBCONFIG_DIR="${DST_DIR}/.jupyter/nbconfig/"
mkdir -p "${JUPYTERNBCONFIG_DIR}"

fsync jupyter/notebook.json "${JUPYTERNB_DIR}"

##################################################
# ssh config
mkdir -p ~/.ssh
fsync ssh_config ~/.ssh/config

##################################################
# git config
fsync git/.gitconfig ~/.gitconfig

printf "${LABEL} done\n"
