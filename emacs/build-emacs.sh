#!/bin/bash -x

# Build latest version of Emacs, version management with stow
# OS: Ubuntu 14.04 LTS and newer
# version: 24.5
# Toolkit: lucid
# $ bash build-emacs.sh
set -eu

readonly version="25.1"

# install dependencies
# sudo apt-get update
# uninstall the old version
# sudo apt-get remove emacs emacs24
sudo apt-get install -y stow build-essential libx11-dev xaw3dg-dev \
    libjpeg-dev libpng12-dev libgif-dev libtiff5-dev libncurses5-dev \
    libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev \
    libxml2-dev libgpm-dev libotf-dev libm17n-dev \
    libgnutls-dev

# download source package
cd ~/Downloads
if [[ ! -d emacs-"$version" ]]; then
    wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
    tar xvf emacs-"$version".tar.xz
fi

# build and install
sudo mkdir -p /usr/local/stow
cd emacs-"$version"
./configure \
    --with-xft \
    --with-x-toolkit=lucid

make
sudo make \
    \
    prefix=/usr/local/stow/emacs-"$version" # install-arch-dep \
# install-arch-indep \

cd /usr/local/stow
sudo stow emacs-"$version"
