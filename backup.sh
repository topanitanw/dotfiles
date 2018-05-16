#!/bin/bash -x

WIN_DST_DIR="~/"
MAC_DST_DIR="/Users/panitanw"
LINUX_DST_DIR="/homes/pwa732/"
DST_DIR=${LINUX_DST_DIR}

function fsync {
	rsync $1 $2
}

fsync ${DST_DIR}/.emacs emacs/.emacs 
fsync ${DST_DIR}/.vimrc vim/.vimrc 
fsync ${DST_DIR}/.bashrc bash/.bashrc 
fsync ${DST_DIR}/.bash_profile bash/.bash_profile 
fsync ${DST_DIR}/.inputrc bash/.inputrc
fsync ${DST_DIR}/.tmux.conf .tmux.conf 
