#!/bin/bash -x

WIN_DST_DIR="~/"
MAC_DST_DIR="/Users/panitanw"
LINUX_DST_DIR="/homes/pwa732/panitanw"
DST_DIR=${LINUX_DST_DIR}

function fsync {
	rsync $1 $2
}

fsync emacs/.emacs ${DST_DIR}
fsync vim/.vimrc ${DST_DIR}
fsync bash/.bashrc ${DST_DIR}
fsync bash/.bash_profile ${DST_DIR}
fsync bash/.inputrc ${DST_DIR}
fsync .tmux.conf ${DST_DIR}
