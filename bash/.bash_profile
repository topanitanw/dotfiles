# .bash_profile

echo "reading bash_profile"
bashrc_path=$HOME/.bashrc
if test -f $bashrc_path; then
    source $bashrc_path
fi

INPUTRC=~/.inputrc
export INPUTRC=~/.inputrc
echo "INPUTRC=$INPUTRC"

if test -f $inputrc_path; then
    bind -f $inputrc_path
fi

# # If not running interactively, don't do anything
# case $- in
#     *i*) ;;
#       *) return;;
# esac
#
# echo "reading ~/.bash_profile"
#
# export PATH="/usr/local/sbin:$PATH"
#
# # added by Anaconda3 installer
# export PATH="/Users/panitanw/anaconda3/bin:$PATH"

# export LC_ALL=en_IN.UTF-8
# export LANG=en_IN.UTF-8
#
source ~/.bashrc
bind -f ~/.inputrc
INPUTRC=${HOME}/.inputrc
