#!/usr/bin/env fish

set SCRIPT_DIR (realpath (dirname (status -f)))


source $SCRIPT_DIR/modules/common.fish


function setup_git
  if install_package git-lfs
    echo "Setup git-lfs"
    git lfs install
  end

  if test ! -L $HOME/.gitconfig.local
    echo "Linking gitconfig"
    ln -s $SCRIPT_DIR/.gitconfig.local $HOME/.gitconfig.local

    git config --global include.path $HOME/.gitconfig.local

    read -p 'set_color green; echo -n "Git user name: "; set_color normal' -l user_name
    read -p 'set_color green; echo -n "Git user email: "; set_color normal' -l user_email

    git config --global user.name $user_name
    git config --global user.email $user_email
  end
end


function setup_neovim
  install_package neovim

  backup_and_link $SCRIPT_DIR/nvim $HOME/.config/nvim

  if read_confirm "Install/Upgrade Neovim Plugins"
    nvim --noplugin +PackerSync +qa
  end
end


function setup_kitty
  install_package kitty

  backup_and_link $SCRIPT_DIR/kitty $HOME/.config/kitty
end


function setup_fish
  set -l fish_shell_passwd (grep -E $USER".*fish" /etc/passwd | string trim)
  if test -z $fish_shell_passwd
    chsh -s (which fish)
  end

  backup_and_link $SCRIPT_DIR/fish $HOME/.config/fish
end


function setup_fnm
  if read_confirm "Install/Upgrade FNM"
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

    $HOME/.fnm/fnm completions --shell fish > $HOME/.config/fish/completions/fnm.fish
  end
end


function setup_docker
  install_package docker
  install_package docker-compose

  if test -z (groups | grep docker)
    echo "Add" $USER "to group docker"
    sudo usermod -aG docker $USER
  end
end


function setup_unity
  # TODO: maybe we can install unity-hub-beta package???
  # or download the app image
  install_package cpio
  install_package visual-studio-code-bin
  install_package dotnet-runtime
  install_package dotnet-sdk
  install_package mono-msbuild
  install_package mono
end


function setup_flutter
  install_package flutter
  if test -z (groups | grep flutterusers)
    sudo gpasswd -a $USER flutterusers
  end

  install_package android-studio
  install_package google-chrome
end

function setup_keyboard_modifiers
  set -l modifiers "ctrl:nocaps,compose:ralt"

  set -l modifiers_found (grep -E $modifiers /etc/X11/xorg.conf.d/00-keyboard.conf | string trim)
  if test -z $modifiers_found
    echo "Setup modifiers in xorg.conf.d"
    localectl set-x11-keymap us "" "" ctrl:nocaps,compose:ralt
  end

  set -l modifiers_found (grep -E $modifiers /etc/default/keyboard | string trim)
  if test -z $modifiers_found
    echo "Setup modifiers in /etc/default/keyboard"
    sudo sed -i 's/XKBOPTIONS=".*"/XKBOPTIONS="ctrl:nocaps,compose:ralt"/g' /etc/default/keyboard
  end
end

function setup_optimus
  install_package optimus-manager
  install_package optimus-manager-qt

  set -l optimus_conf /etc/optimus-manager/optimus-manager.conf
  if test ! -e $optimus_conf
    sudo cp /usr/share/optimus-manager.conf $optimus_conf

    sudo sed -i 's/dynamic_power_management=.*/dynamic_power_management=fine/g' $optimus_conf
    sudo sed -i 's/startup_mode=.*/startup_mode=hybrid/g' $optimus_conf
  end
end

setup_keyboard_modifiers

install_package steam
install_package spotify

install_package nerd-fonts-fira-code
install_package starship
install_package xclip

# bluetooth
install_package bluez
install_package bluez-utils
install_package blueberry

# utilities
install_package ripgrep
install_package fd
install_package optipng
install_package pngquant
install_package dua-cli
install_package bottom
install_package exa
install_package foliate

# cloud
install_package google-cloud-sdk
install_package kubectl
install_package sops
install_package aws-cli

# development
setup_docker
install_package python-poetry
install_package python-tox
install_package pyenv
install_package postgresql-libs
install_package go

setup_git
setup_neovim
setup_fish
setup_kitty
setup_fnm
setup_unity
setup_flutter

# XFCE
# Setup whisker menu
# Setup appearance
#   - Change icons
#   - Set Fonts
# Setup Window Manager
#   - Change Fonts
#   - Remove shade icon from bar
#   - Shortcut
# Setup Window Manager Tweaks
#   - Focus beahvior switch
