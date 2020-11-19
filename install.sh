#!/bin/bash

LABEL="[INSTALL]"
DST_DIR="${HOME}"

printf "${LABEL} home directory: ${DST_DIR}\n"

function sync {
    # check if the file exists
    if [ ! -f $1 ]; then
        return 0
    fi

    printf "${LABEL} sync ${1} ${2}\n"
    rsync $1 $2
}

function symlink {
    # check if the file exists
    if [ ! -f $1 ]; then
        return 0
    fi

    local filename=`basename $1`
    printf "${LABEL} symlink ${1} ${2}/$filename\n"
    ln -sf `pwd`/$1 $2/${filename}
}

function cp_template {
    # check if the file exists, do not copy.
    if [ -f $2 ]; then
        return 0
    fi

    printf "${LABEL} cp_template ${1} ${2}\n"
    rsync $1 $2
}


##################################################
# text editor
symlink emacs/.emacs "${DST_DIR}"
symlink vim/.vimrc "${DST_DIR}"

##################################################
# nvim config
CONFIG_DIR="${DST_DIR}/.config"
mkdir -p "${CONFIG_DIR}"

NVIM_DIR="${CONFIG_DIR}/nvim"
mkdir -p "${NVIM_DIR}"

symlink vim/init.vim "${NVIM_DIR}"

##################################################
# bash shell file
# fsync bash/.bashrc "${DST_DIR}"
# fsync bash/.bash_profile "${DST_DIR}"
# fsync bash/.inputrc "${DST_DIR}"

symlink bash/.bashrc "${DST_DIR}"
SHELLFILES_DIR="${DST_DIR}/.shell_files"
mkdir -p "${SHELLFILES_DIR}"

cp_template bash/alias_command.sh \
    "${SHELLFILES_DIR}"/alias_command.sh

cp_template bash/private_environment.sh \
    "${SHELLFILES_DIR}"/private_environment.sh

cp_template bash/bash_function.sh ${SHELLFILES_DIR}

# shell file
##################################################
# etc
symlink .tmux.conf "${DST_DIR}"
symlink .pylintrc "${DST_DIR}"

##################################################
# jupyter notebook
JUPYTERNB_DIR="${DST_DIR}/.jupyter"
mkdir -p "${JUPYTERNB_DIR}"

JUPYTERNBCONFIG_DIR="${DST_DIR}/.jupyter/nbconfig/"
mkdir -p "${JUPYTERNBCONFIG_DIR}"

symlink jupyter/notebook.json "${JUPYTERNB_DIR}"

##################################################
# ssh config
mkdir -p ~/.ssh
symlink ssh_config ~/.ssh/config

##################################################
# git config
symlink git/.gitconfig ~/.gitconfig
git config --global

printf "${LABEL} done\n"
