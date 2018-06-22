#!/bin/bash

USERNAME="pwongseammat"
WIN_BASH_DST_DIR="/home/${USERNAME}"
MAC_DST_DIR="/Users/${USERNAME}"
LINUX_DST_DIR="/home/${USERNAME}"
DST_DIR="${MAC_DST_DIR}"

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


