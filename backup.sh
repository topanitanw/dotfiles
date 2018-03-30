#!/bin/bash -x

SRC_DIR="/Users/panitanw"

function fsync {
	rsync $1 $2
}

fsync ${SRC_DIR}/.emacs emacs/.emacs 
fsync ${SRC_DIR}/.vimrc vim/.vimrc 
fsync ${SRC_DIR}/.bashrc bash/.bashrc 
fsync ${SRC_DIR}/.bash_profile bash/.bash_profile 
fsync ${SRC_DIR}/.inputrc bash/.inputrc
