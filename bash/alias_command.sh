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
alias mclmck="make clean; make check;";
alias mclmal="make clean; make all;";
alias mcl="make clean;";
alias mck="make check;";
alias mal="make all;";
alias mii="make isoimage;";
alias mmcf="make menuconfig;";

## alias rm
alias rm="rm -i";
alias rmswp="rm .*.swp; rm *~;";

## alias ls
alias ll="ls -lah";

# project specific
alias rmll="rm *.ll;";
alias rmbc="rm *.bc;";
alias rme="./run_me.sh;";
alias mbcO0="clang -I../misc -O0 -emit-llvm -c program.c -o program.bc;";
