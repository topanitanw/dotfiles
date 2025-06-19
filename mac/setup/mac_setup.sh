#!/bin/bash -x

# Emacs setup for Mac
# enable the meta key
# Terminal menu > Preferences > Settings > Keyboard > Use option as meta key
# In Mac Terminal.app this setting is Preferences > Profiles tab >
# Keyboard sub-tab > at the bottom "Use option as meta key."

git_root=$(git rev-parse --show-toplevel 2>/dev/null)

source "$git_root/bash/bash_function.sh"

# iTerm2 Setup
# - set alt keys
#   Preferences > Profiles tab > Keys
#   sub-tab > at the bottom of the window set "left/right option key
#   acts as" to "+Esc".
# - smart cursor colors
#   pref > profiles > colors > smart colors

# In GNOME terminal
# - enable the alt keys
#   Edit > Keyboard Shortcuts > uncheck "Enable menu access keys."
#
# (setq mac-option-key-is-meta nil
#       mac-command-key-is-meta t
#       mac-command-modifier 'meta
#       mac-option-modifier 'none)

# prerequisite programs
# ask for the admin password
sudo -v

xcode-select --install

infop "installing homebrew"
if test -z "$(which brew)"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    errorp "brew exists. Skip its installation"
fi

infop "running brew update"
brew update

infop "running brew upgrade"
brew upgrade

infop "setting bash as the default shell"
chsh -s /bin/bash

infop "install programs from Brewfile"
brewfile_path=mac/Brewfile
if test -f $brewfile_path; then
    # install the packages from the brewfile
    brew bundle --file brewfile_path
else
    echo "pwd: $(pwd)"
    errorp "there is no Brewfile\n"
    exit -1
fi

# there is a setup for iterm in mac_script.txt
infop "running mac_scripts.sh"
mac_setup_script_path=mac/setup/mac_scripts.sh
if test -f $mac_setup_script_path; then
    bash $mac_setup_script_path
else
    errorp "there is no $mac_setup_script_path\n"
fi

infop "creating ~/.config"
if ! test -d ~/.config; then
    mkdir -p ~/.config
fi

# create the directory to store git repositories if it does not exist
repo_dir=~/work/git_repository
infop "creating $repo_dir"
if ! test -d $repo_dir; then
    mkdir -p $repo_dir
fi

# create the .nvim directory if it does not exist
nvim_config_path=~/.config/nvim
if ! test -d $nvim_config_path; then
    mkdir -p $nvim_config_path
fi

# link the .vim and .vimrc so that nvim does not need to download the
# same plugins as vim
ln -s ~/.vim $nvim_config_path
ln -s ~/.vimrc ~/.config/nvim/init.vim

# cd $repo_dir
# git clone https://github.com/topanitanw/dotfiles.git
# cd dotfiles && bash install.sh

infop "running brew cleanup"
brew cleanup -s

# GUI

## iterm
### enable alt + d or alt + back space
#### Go to iTerm Preferences → Profiles, select your profile, then the Keys tab.
#### Click Load Preset... and choose Natural Text Editing.
### enable alt as meta
#### Go to iTerm Preferences → Profiles, select your profile, then the Keys tab.
#### left option key, right option key Esc+

## Sound
### system peference -> sound -> show volume in menu bar
