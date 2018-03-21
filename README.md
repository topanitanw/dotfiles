# Dotfiles Setup for Linux Systems

This repository contains my dotfiles to set up Linux tools as follows: 

* vim 
* gvim
* emacs 
* bash
* tmux 
   
I plan to update this repository to keep track of packages/plugins I install in those two text editors.

---

## How to install these dotfiles

If you want to install these dotfiles into your system, please follow the steps below

1. clone this repository
        
        > git clone https://github.com/topanitanw/dotfiles.git dotfiles
        
2. go into the dotfiles directory
    
        > cd dotfiles 
        
3. run the install.sh script
    
        > bash install.sh
        
    Note that the script will place init files of emacs, vim, and bash to the home directory.
       
4. copy dotfiles back to the repository by running the following commands
    
        > bash backup.sh

--- 
