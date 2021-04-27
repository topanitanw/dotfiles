# alias
## common alias
alias grep='grep --color=auto' ;
alias fgrep='fgrep --color=auto' ;
alias egrep='egrep --color=auto' ;
alias pdfgrep='pdfgrep --color=auto';

## personal alias
alias source_bash="source ~/.bashrc;";
alias llvm_cat="cd ~/my_folder/496F2017/CAT-c;";
alias cd_496="cd ~/my_folder/496F2017/;";

## alias make
alias mcl="make clean;";
alias mck="make check;";
alias mal="make all;";
alias mii="make isoimage;";
alias mmcf="make menuconfig;";

alias watch-condor="watch -n 2 condor_q;";
alias condor-hold-reason="condor_q -hold -af HoldReason;";
alias condor-verbose="condor_q -verbose -long";
alias condor-mq="printf \"%9s | %7s | %37s | %s | %s \\n\" \"Id\" \"Owner\" \"HostName\" \"St\" \"Cmd\"; condor_q -submitter pwa732 -format \"%5d.\" ClusterId -format \"%d |\" ProcId -format \" %7s | \" Owner -format \" %36s |
    \" RemoteHost -format \" %2s \" JobStatus -format \"| %s\\n\" Cmd"

## alias rm
### trash-put should be install by pip install trash-cli
### use trash-list to access the file in the trash
### If you need to use the rm command, please use \rm to escape the rm.
alias rm="echo 'You are supposed to use trash-put instead'";
alias rmswp="rm .*.swp; rm *~;";

## alias ls
alias ll="ls -lah";

# project specific
alias rmll="rm *.ll;";
alias rmbc="rm *.bc;";
alias rme="./run_me.sh;";
alias mbcO0="clang -I../misc -O0 -emit-llvm -c program.c -o program.bc;";
