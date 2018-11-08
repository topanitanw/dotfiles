#!/bin/bash -x

DST_DIR="${HOME}"

function fsync {
	rsync $1 $2
}

fsync ${DST_DIR}/.emacs emacs/.emacs 
fsync ${DST_DIR}/.vimrc vim/.vimrc 
fsync ${DST_DIR}/.bashrc bash/.bashrc 
fsync ${DST_DIR}/.bash_profile bash/.bash_profile 
fsync ${DST_DIR}/.inputrc bash/.inputrc
fsync ${DST_DIR}/.tmux.conf .tmux.conf 
