#!/bin/bash -x

LABEL="[BACKUP]"
DST_DIR="${HOME}"
printf "home directory: ${DST_DIR}\n"

function fsync {
    # check if the file exists
    if [ ! -f $1 ]; then
        return 0
    fi

    printf "${LABEL} ${1} ${2}\n"
    rsync $1 $2
}

fsync ${DST_DIR}/.emacs emacs/.emacs 
fsync ${DST_DIR}/.vimrc vim/.vimrc 

fsync ${DST_DIR}/.bashrc bash/.bashrc 
fsync ${DST_DIR}/.bash_profile bash/.bash_profile 
fsync ${DST_DIR}/.shell_files/bash_fuction.sh bash/bash_function.sh

fsync ${DST_DIR}/.inputrc bash/.inputrc
fsync ${DST_DIR}/.tmux.conf .tmux.conf 

CONFIG_DIR="${DST_DIR}/.config"
NVIM_DIR="${CONFIG_DIR}/nvim"
fsync "${NVIM_DIR}/init.vim" vim/init.vim 

JUPYTERNB_DIR="${DST_DIR}/.jupyter/nbconfig"
fsync "${JUPYTERNB_DIR}/notebook.json" jupyter/notebook.json

printf "${LABEL} done\n"
