#!/bin/bash
# .bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=linux;;
    Darwin*)    machine=mac;;
    CYGWIN*)    machine=cygwin;;
    MINGW*)     machine=mingw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "machine: ${machine}"
echo "path: ${PATH}"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/usr/local/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

echo "reading ~/.bashrc"
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
    echo "reading bash_completion.sh"
    . "/usr/local/etc/profile.d/bash_completion.sh"
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
    PS1='\s \[\e[1;32;40m(\e[m\] \[\e[1;31m\u\e[m\]@\[\e[1;30m\h\e[m\] : \[\e[0;36m\w\e[m\] \[\e[1;32;40m)\e[m\] $(__git_ps1 "[%s]")\n\$ '
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
    function clear(){
        vterm_printf "51;Evterm-clear-scrollback";
        tput clear;
    }
fi

echo "path v2: ${PATH}"
FILE_BASH_FUNCTION=${SHELL_DIR}/bash_function.sh
source ${FILE_BASH_FUNCTION}

FILE_PRIVATE_ENV=${SHELL_DIR}/private_environment.sh
check_source ${FILE_PRIVATE_ENV}

FILE_ALIAS_COM=${SHELL_DIR}/alias_command.sh
check_source ${FILE_ALIAS_COM}
