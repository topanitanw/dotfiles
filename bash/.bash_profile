# .bash_profile
#
# Note that some commands such as scp require that
# remote shell produces no output for non-interactive sessions.
#
# Thus, if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

echo "reading bash_profile"

bashrc_path=$HOME/.bashrc
if test -f $bashrc_path; then
    echo "reading $bashrc_path"
    source $bashrc_path
fi

INPUTRC=~/.inputrc
export INPUTRC=~/.inputrc
if test -f $INPUTRC; then
    echo "reading $INPUTRC"
    bind -f $INPUTRC
fi

# export PATH="/usr/local/sbin:$PATH"
#
# # added by Anaconda3 installer
# export PATH="/Users/panitanw/anaconda3/bin:$PATH"

# export LC_ALL=en_IN.UTF-8
# export LANG=en_IN.UTF-8


# source ~/.bashrc
# bind -f ~/.inputrc
# INPUTRC=${HOME}/.inputrc
