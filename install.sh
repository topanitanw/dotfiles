#!/bin/bash

DST_DIR="${HOME}"
printf "home directory: ${DST_DIR}\n"

function fsync {
	rsync $1 $2
}

fsync emacs/.emacs "${DST_DIR}"
fsync vim/.vimrc "${DST_DIR}"
fsync bash/.bashrc "${DST_DIR}"
fsync bash/.bash_profile "${DST_DIR}"
fsync bash/.inputrc "${DST_DIR}"
fsync .tmux.conf "${DST_DIR}"
fsync .pylintrc "${DST_DIR}"

CONFIG_DIR="${DST_DIR}/.config"
if [ ! -d "${CONFIG_DIR}" ]; then
  mkdir "${CONFIG_DIR}"
fi

NVIM_DIR="${CONFIG_DIR}/nvim"
if [ ! -d "${NVIM_DIR}" ]; then
  mkdir "${NVIM_DIR}"
fi
fsync init.vim "${NVIM_DIR}"

JUPYTERNB_DIR="${DST_DIR}/.jupyter/nbconfig/"
if [ ! -d "${JUPYTERNB_DIR}" ]; then
  mkdir "${JUPYTERNB_DIR}"
fi 
fsync jupyter/notebook.json "${JUPYTERNB_DIR}"



