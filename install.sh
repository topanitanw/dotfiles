#!/bin/bash

WIN_DST_DIR="~/"
MAC_DST_DIR="/Users/panitanw"
DST_DIR=${WIN_DST_DIR}

function fsync {
	rsync $1 $2
}

fsync emacs/.emacs ${DST_DIR}
fsync vim/.vimrc ${DST_DIR}
fsync bash/.bashrc ${DST_DIR}
fsync bash/.bash_profile ${DST_DIR}
fsync bash/.inputrc ${DST_DIR}
