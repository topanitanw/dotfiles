#!/bin/bash -x

LABEL="[INSTALL]"
DST_DIR="${HOME}"

printf "${LABEL} home directory: ${DST_DIR}\n"

function sync {
    # check if the file exists
    if [ ! -f "$1" ]; then
        return 0
    fi

    printf "${LABEL} sync ${1} ${2}\n"
    rsync $1 $2
}

# symlink the file to the destination directory
# if the file exists, do not symlink
# $1: source file
# $2: destination directory
# $3: destination filename
# Ex: symlink .bashrc ${HOME}
function symlink {
    # don't symlink if the file exists
    local filename=`basename $1`
    # if the 3rd argument is not empty, use it as the filename
    if [ ! -z "$3" ]; then
        filename="$3"
    fi

    local dst_file_path="$2/$filename"
    if [ -f "$dst_file_path" ]; then
        printf "${LABEL} skipping ${dst_file_path} exists\n"
        return 0
    fi

    printf "${LABEL} symlink ${1} ${2}/$filename\n"
    ln -sf `pwd`/$1 $dst_file_path
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

symlink bash/alias_command.sh \
    "${SHELLFILES_DIR}"

symlink bash/bash_function.sh \
    "${SHELLFILES_DIR}"

cp_template bash/private_environment.sh \
    "${SHELLFILES_DIR}"/private_environment.sh

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
    printf "${LABEL} tpm exists\n"
else
    printf "${LABEL} tpm does not exist\n"
    pushd ${HOME}
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    popd
fi

symlink ./tmux/.tmux.conf "${DST_DIR}"

YADF_CONFIG_DIR="${HOME}/.config/yapf"
mkdir -p "${YADF_CONFIG_DIR}"
symlink formatter/.style.yapf "${YADF_CONFIG_DIR}" "style"

## git config --file ~/.gitconfig
printf "${LABEL} done\n"
