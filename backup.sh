#!/bin/bash -x

LABEL="[BACKUP]"
DST_DIR="${HOME}"
printf "home directory: ${DST_DIR}\n"

function fsync {
  printf "${LABEL} ${1} ${2}\n"
	rsync $1 $2
}

fsync ${DST_DIR}/.emacs emacs/.emacs 
fsync ${DST_DIR}/.vimrc vim/.vimrc 
fsync ${DST_DIR}/.bashrc bash/.bashrc 
fsync ${DST_DIR}/.bash_profile bash/.bash_profile 
fsync ${DST_DIR}/.inputrc bash/.inputrc
fsync ${DST_DIR}/.tmux.conf .tmux.conf 

CONFIG_DIR="${DST_DIR}/.config"
NVIM_DIR="${CONFIG_DIR}/nvim"
if [ ! -d "${NVIM_DIR}" ]; then
  fsync "${NVIM_DIR}/init.vim" vim/init.vim 
fi

JUPYTERNB_DIR="${DST_DIR}/.jupyter/nbconfig"
if [ ! -d "${JUPYTERNB_DIR}" ]; then
  mkdir "${JUPYTERNB_DIR}/notebook.json" jupyter/notebook.json
fi 
printf "${LABEL} done\n"
