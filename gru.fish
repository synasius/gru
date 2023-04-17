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

  backup_and_link $SCRIPT_DIR/nvim/custom $HOME/.config/nvim/lua/custom
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
  install_package fnm-bin

  # Completions need to be generate because PKGBUILD doesn't
  fnm completions --shell fish > $HOME/.config/fish/completions/fnm.fish
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
  install_package unityhub

  # To support progressive lightmapper GPU
  install_package clinfo
  install_package ocl-icd
  install_package opencl-headers
  install_package opencl-nvidia

  # To support install of Android SDK
  install_package cpio

  # Other tools for scripting
  install_package visual-studio-code-bin
  install_package dotnet-runtime
  install_package dotnet-sdk
  install_package mono-msbuild
  install_package mono
end

function setup_flutter
  install_package fvm-bin

  install_package android-studio

  # For web build
  install_package google-chrome

  # For desktop support
  install_package clang
  install_package cmake
  install_package ninja
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

function setup_pipewire
  backup_and_link $SCRIPT_DIR/pipewire $HOME/.config/pipewire
end

function setup_starship
  install_package starship
  backup_and_link $SCRIPT_DIR/starship.toml $HOME/.config/starship.toml
end

function setup_shell_themes
  set -l themes_dir $HOME/.config/gruthemes
  if test ! -d $themes_dir
    git clone git@github.com:folke/tokyonight.nvim.git $themes_dir --depth 1 
  else
    git -C $themes_dir pull
  end
end

setup_pipewire
setup_keyboard_modifiers

# entertainment
install_package steam
install_package wine
install_package itch-bin
install_package lutris

flatpak install com.spotify.Client
flatpak install md.obsidian.Obsidian
flatpak install com.gitlab.newsflash
install_package discord
install_package foliate
install_package shotwell

# Study
flatpak install net.ankiweb.Anki

# shell
setup_starship
#install_package nerd-fonts-fira-code
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
install_package google-cloud-cli
install_package google-cloud-cli-gke-gcloud-auth-plugin
install_package kubectl
install_package sops
install_package aws-cli
install_package helm

# development
setup_docker
install_package python-poetry
install_package python-tox
install_package pyenv
install_package postgresql-libs
install_package xorg-server-xvfb

# For integration testing
install_package google-chrome
install_package chromedriver

# graphics and media
install_package gimp
flatpak install org.inkscape.Inkscape
flatpak install org.kde.digikam
install_package krita
install_package simple-scan
install_package evince
install_package xf86-input-wacom
install_package libwacom
install_package pureref
install_package perl-image-exiftool
install_package jhead
install_package obs-studio

# Mega client
install_package megasync-bin
install_package nautilus-megasync

setup_git
setup_neovim
setup_fish
setup_kitty
setup_fnm

# game dev
setup_unity
install_package godot
install_package godot-mono-bin
install_package godot4-bin

setup_flutter

# Flutter
# Run `flutter doctor`
# Install Android SDK and SDK Commandline Tools
# Accept licenses `flutter doctor --android-licenses`
