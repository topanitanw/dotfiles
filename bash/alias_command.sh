# alias
## common alias
alias grep='grep --color=auto' ;
alias fgrep='fgrep --color=auto' ;
alias egrep='egrep --color=auto' ;
alias pdfgrep='pdfgrep --color=auto';

## personal alias
alias source_bash="source ~/.bashrc;";

## alias make
alias mal="make all";
alias mbu="make build";
alias mcl="make clean";
alias mck="make check";
alias mfo="make format";
alias mre="make report";
alias mru="make run";
alias mte="make test";
alias mme="make menuconfig";
alias cdgr='cd "$(git rev-parse --show-toplevel)"'

alias wcon="watch -n 2 condor_q;";
alias conhold="condor_q -hold -af HoldReason;";
alias conver="condor_q -verbose -long";
alias condor-mq="printf \"%9s | %7s | %37s | %s | %s \\n\" \"Id\" \"Owner\" \"HostName\" \"St\" \"Cmd\"; condor_q -submitter pwa732 -format \"%5d.\" ClusterId -format \"%d |\" ProcId -format \" %7s | \" Owner -format \" %36s |
    \" RemoteHost -format \" %2s \" JobStatus -format \"| %s\\n\" Cmd"

## JobStatus in job ClassAds
## http://pages.cs.wisc.edu/~adesmet/status.html
## |----+----------------+---|
## | No | Status         |   |
## |----+----------------+---|
## |  0 | Unexpanded     | U |
## |  1 | Idle           | I |
## |  2 | Running        | R |
## |  3 | Removed        | X |
## |  4 | Completed      | C |
## |  5 | Held           | H |
## |  6 | Submission_err | E |


## alias rm
### trash-put should be install by pip install trash-cli
### use trash-list to access the file in the trash
### If you need to use the rm command, please use \rm to escape the rm.
# alias rm="echo 'You are supposed to use trash-put instead'";
alias rmswp="rm .*.swp; rm *~;";

## alias ls
### Use a long listing format ##
alias ll="ls -lah";

## Colorize the ls output ##
alias ls='ls --color=auto'

## Show hidden files ##
alias l.='ls -d .* --color=auto'

# project specific
