#!/bin/bash
# Fig pre block. Keep at the top of this file.
# [[ -f "$HOME/.fig/shell/bashrc.pre.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.pre.bash"

# bash_func_file_path="${HOME}/.shell_files/bash_function.sh"
# if test -f "${bash_func_file_path}"; then
#     # echo "reading ${bash_func_file_path}"
#     source "${bash_func_file_path}"
# else
#     echo "bash function file not found: ${bash_func_file_path}"
# fi

# If not running interactively, don't do anything
case $- in
    *i*) # this is an interactive shell.
        ;;
    *)   # this is the non-interactive shell
        return;;
esac

# if [[ $- == *i* ]]; then
#     echo "This is an interactive shell"
# else
#     echo "This is a non-interactive shell"
# fi
#
# if shopt -q login_shell; then
#     echo "This is a login shell"
# else
#     echo "This is a non-login shell"
# fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=linux;;
    Darwin*)    machine=mac;;
    CYGWIN*)    machine=cygwin;;
    MINGW*)     machine=mingw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
# echo "machine: ${machine}"
# echo "path: ${PATH}"
echo "reading ~/.bashrc"

# Fig pre block. Keep at the top of this file.
# FIG_FILE="$HOME/.fig/shell/bashrc.pre.bash"
# if [ -f  "${FIG_FILE}" ]; then
#     . "${FIG_FILE}"
#     # echo "reading ${FIG_FILE}"
# fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if test "${machine}" == "mac"; then
    bash_completion_path="/opt/homebrew/etc/profile.d/bash_completion.sh"
    if test -f "${bash_completion_path}"; then
        echo "reading bash_completion.sh"
    fi
fi

SHELL_DIR="${HOME}/.shell_files"
# create a keep the shell related files
mkdir -p "${SHELL_DIR}"

if [ ! -f ${SHELL_DIR}/git-completion.bash ]; then
    pushd .
    cd ${SHELL_DIR}
    echo "download git-completion.bash"
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    popd
fi
source ${SHELL_DIR}/git-completion.bash

if [ ! -f ${SHELL_DIR}/git-prompt.sh ]; then
    pushd .
    cd ${SHELL_DIR}
    echo "download git-prompt.sh"
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
    popd
fi
source ${SHELL_DIR}/git-prompt.sh

function get_git_ps1() {
    echo '$(__git_ps1 "[%s]")'
}

# change the shell prompt
if [ $(id -u) -eq 0 ]; then # you are root, set red colour prompt
    PS1="\\[$(tput setaf 1)\\]\\u@\\h:\\w \n#\\[$(tput sgr0)\\]"
else # normal
    # \s shell
    # \u user
    # \h hostname
    # \w working directory
    # __git_ps1 git branch name
    # set if the repo is dirty, show it.
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWCONFLICTSTATE="yes"
    export GIT_PS1_SHOWUPSTREAM="verbose"

    black_bg="\[\e[0;40m\]"
    white_fg="\[\e[0;1m\]"
    lightblue_fg="\[\e[0;1;38;5;33m\]"
    gray_fg="\[\e[0;1;38;5;247m\]"
    lightgreen_fg="\[\e[0;38;5;70m\]"
    cancel="\[\e[0m\]"
    shell_prompt="${black_bg}${white_fg}\s ( ${lightblue_fg}\u ${white_fg}@ ${gray_fg}\h ${white_fg}: ${lightgreen_fg}\w ${white_fg}) $(get_git_ps1)${cancel}\n"
    PS1=${shell_prompt}
fi

# setting terminal to handle 256 colors
TERM=xterm
if [ "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
fi

export CLICOLOR=1

# highlight colors for the ls command
# https://geoff.greer.fm/lscolors/
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# User specific aliases and functions
# enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)" ;
    alias ls='ls --color=auto' ;
    #alias dir='dir --color=auto' ;
    #alias vdir='vdir --color=auto' ;
fi

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    function clear() {
        vterm_printf "51;Evterm-clear-scrollback";
        tput clear;
    }
fi

FILE_BASH_FUNCTION=${SHELL_DIR}/bash_function.sh
source ${FILE_BASH_FUNCTION}

FILE_PRIVATE_ENV=${SHELL_DIR}/machine_specific.sh
check_source ${FILE_PRIVATE_ENV}

FILE_ALIAS_COM=${SHELL_DIR}/alias_command.sh
check_source ${FILE_ALIAS_COM}

echo "reading the inputrc"
INPUTRC="~/.inputrc"
echo "inputrc=$INPUTRC"
bind -f ~/.inputrc
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'
bind '"jk":vi-movement-mode'
