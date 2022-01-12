#!/usr/bin/env fish

set SCRIPT_DIR (realpath (dirname (status -f)))


source $SCRIPT_DIR/modules/common.fish


function install_package -a package
  if test -z (yay -Q $package)
    echo "Install" $package
    yay -S $package
    return 0
  else
    echo $package "already installed"
    return 1
  end
end


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
    newgrp flutterusers
  end

  install_package android-studio
  install_package google-chrome
end

# TODO: setup keyboard options
# /etc/default/keyboard
# /etc/X11/xorg.conf.d/00-keyboard.conf

install_package optimus-manager
install_package optimus-manager-qt

# TODO:  nvidia-installer-dkms

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
