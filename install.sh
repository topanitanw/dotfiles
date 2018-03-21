#!/bin/bash

DST_DIR="/Users/panitanw"

function fsync {
	rsync $1 $2
}

fsync emacs/.emacs ${DST_DIR}
fsync vim/.vimrc ${DST_DIR}
fsync bash/.bashrc ${DST_DIR}
fsync bash/.bash_profile ${DST_DIR}
