#!/bin/bash
# .bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

echo "reading ~/.bashrc"
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

SHELL_DIR="${HOME}/.shell_files"
# create a keep the shell related files
mkdir -p "${SHELL_DIR}"

if [ ! -f ${SHELL_DIR}/git-completion.bash ]; then
  pushd .
  cd ${SHELL_DIR}
  wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
  popd
fi
source ${SHELL_DIR}/git-completion.bash

if [ ! -f ${SHELL_DIR}/git-prompt.sh ]; then
  pushd .
  cd ${SHELL_DIR}
  wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
  popd
fi
source ${SHELL_DIR}/git-prompt.sh

# change the shell prompt
if [ $(id -u) -eq 0 ]; then # you are root, set red colour prompt
  PS1="\\[$(tput setaf 1)\\]\\u@\\h:\\w \n#\\[$(tput sgr0)\\]"
else # normal
  PS1='\s \e[1;32;40m(\e[m \e[1;31m\u\e[m@\e[1;30m\h\e[m: \e[0;36m\w\e[m \e[1;32;40m)\e[m \n$ '
fi

# setting terminal to handle 256 colors
TERM=xterm
if [ "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
fi

export CLICOLOR=1

# highlight colors for the ls command
# https://geoff.greer.fm/lscolors/
export LSCOLORS=ExFxBxDxCxegedabagacad

# User specific aliases and functions 
# enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)" ;
    alias ls='ls --color=auto' ;
    #alias dir='dir --color=auto' ;
    #alias vdir='vdir --color=auto' ;
fi

PRIVATE_ENV=${SHELL_DIR}/private_environment.sh
if [ ! -f ${PRIVATE_ENV} ]; then
    source ${PRIVATE_ENV} 
else 
    printf "no ${PRIVATE_ENV}\n"
fi 

ALIAS_COM=${SHELL_DIR}/alias_command.sh
if [ ! -f ${ALIAS_COM} ]; then 
    source ~/.shell_files/alias_command.sh
else
    printf "no ${ALIAS_COM}\n"
fi
