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

# create a directory to keep the shell related files
if [ ! -d ~/shell_files ]; then
  mkdir ~/shell_files
fi

if [ ! -f ~/shell_files/git-completion.bash ]; then
  cd ~/shell_files
  wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
fi 
source ~/git-completion.bash

if [ ! -f ~/shell_files/git-prompt.sh ]; then
  cd ~/shell_files
  wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
fi
source ~/git-prompt.sh

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
export LSCOLORS=ExFxBxDxCxegedabagacad

# User specific aliases and functions

# enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)" ;
    alias ls='ls --color=auto' ;
    #alias dir='dir --color=auto' ;
    #alias vdir='vdir --color=auto' ;
    alias grep='grep --color=auto' ;
    alias fgrep='fgrep --color=auto' ;
    alias egrep='egrep --color=auto' ;
    alias pdfgrep='pdfgrep --color=auto';
fi

alias source_bash="source ~/.bashrc;";
alias llvm_cat="cd ~/my_folder/496F2017/CAT-c;";
alias cd_496="cd ~/my_folder/496F2017/;";
alias mclmck="make clean; make check;";
alias mclm="make clean; make;";
alias mcl="make clean;";
alias mck="make check;";
alias mall="make all;";
alias rm="rm -i";
alias rmswp="rm .*.swp; rm *~;";

# project specific 
alias rmll="rm *.ll;";
alias rmbc="rm *.bc;";
alias rme="./run_me.sh;";
alias mbcO0="clang -I../misc -O0 -emit-llvm -c program.c -o program.bc;";
alias llvm_cat="cd ~/my_folder/496F2017/CAT-c;";
alias cd_496="cd ~/my_folder/496F2017/;";
alias mii="make isoimage;";
alias mmcf="make menuconfig;";
alias ll="ls -la";

# Minet setup
# export PATH=$PATH:/home/pwa732/my_folder/TA/340W2017/p1/minet-netclass
# export PATH=$PATH:/home/pwa732/my_folder/TA/340W2017/p1/machel/minet-netclass-w15/
alias mbcO0="clang -I../misc -O0 -emit-llvm -c program.c -o program.bc;";
alias mall="make all;";
alias rme="./run_me.sh;";
alias rm="rm -i";
alias rmll="rm *.ll;";
alias rmbc="rm *.bc;";
alias rmswp="rm .*.swp; rm *~;";
alias mii="make isoimage;";
alias mmcf="make menuconfig;";
# Minet setup
# export PATH=$PATH:/home/pwa732/my_folder/TA/340W2017/p1/minet-netclass
export PATH=$PATH:/home/pwa732/my_folder/TA/340W2017/p1/machel/minet-netclass-w15/

# # user specific environment and startup programs
# export PATH=~/CAT/bin:$PATH
# source /opt/rh/devtoolset-6/enable;
# 
# # llvm
# LLVM_HOME=/home/software/llvm
# export PATH=$LLVM_HOME/bin:$PATH
# export LD_LIBRARY_PATH=$LLVM_HOME/lib:$LD_LIBRARY_PATH

# Anaconda 3.5
export PATH=/usr/local/anaconda3/bin:"$PATH"
