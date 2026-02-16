#!/bin/bash -x

git_root=$(git rev-parse --show-toplevel 2>/dev/null)

# force to source the functions in this file.
source $git_root/bash/bash_function.sh $(pwd)/bash

LABEL="[INSTALL]"
DST_DIR="${HOME}"

infop "destination directory = ${DST_DIR}"

# function sync {
#     # check if the file exists
#     if [ ! -f "$1" ]; then
#         return 0
#     fi
#
#     infop "sync ${1} ${2}\n"
#     rsync $1 $2
# }

function cp_template {
    # check if the file exists, do not copy.
    if [ -f $2 ]; then
        return 0
    fi

    infop "cp_template ${1} ${2}\n"
    rsync $1 $2
}

##################################################
# text editor
symlink emacs/.emacs "${DST_DIR}"
cp_template emacs/.emacs-init-machine.el "${DST_DIR}/.emacs-init-machine.el"
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
symlink bash/.bashrc "${DST_DIR}"
symlink bash/.bash_profile "${DST_DIR}"
symlink bash/.inputrc "${DST_DIR}"

SHELLFILES_DIR="${DST_DIR}/.shell_files"
mkdir -p "${SHELLFILES_DIR}"

symlink bash/alias_command.sh "${SHELLFILES_DIR}"
symlink bash/p8_functions.bash "${SHELLFILES_DIR}"

symlink_force bash/bash_function.sh "${SHELLFILES_DIR}"
symlink_force bash/bash_functions_etc.bash "${SHELLFILES_DIR}"

cp_template bash/machine_specific.sh "${SHELLFILES_DIR}"/machine_specific.sh

# shell file
##################################################
# etc
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
symlink ssh_config ${HOME}/.ssh

##################################################
# git config
symlink git/.gitconfig ${HOME}
# git config --file ~/.gitconfig

symlink git/.gitignore ${HOME} .gitignore_global

##################################################
# inputrc
symlink readline/.inputrc ${HOME}

##################################################
# tmux
# set up
# tmux must be 1.9 or higher
# test if tpm exists
if test -d ~/.tmux/plugins/tpm; then
    infop "tpm exists"
else
    infop "tpm does not exist"
    pushd ${HOME}
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    popd
fi

symlink ./tmux/.tmux.conf "${DST_DIR}"

YADF_CONFIG_DIR="${HOME}/.config/yapf"
mkdir -p "${YADF_CONFIG_DIR}"
symlink formatter/.style.yapf "${YADF_CONFIG_DIR}" "style"

## git config --file ~/.gitconfig
infop "done\n"
