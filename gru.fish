#!/usr/bin/env fish

set SCRIPT_DIR (realpath (dirname (status -f)))

source $SCRIPT_DIR/modules/common.fish

function read_confirm --description 'Ask the user for confirmation' --argument prompt default
  if test -z "$prompt"
    set prompt "Continue?"
  end 
  
  set -l choice "[Y/n]"
  switch $default
    case N n
      set choice "[y/N]"
      set default_return 1
    case '*'
      set default "Y"
      set default_return 0
  end
      
  while true
    read -p 'set_color green; echo -n "$prompt $choice: "; set_color normal' -l confirm

    switch $confirm
      case Y y 
        return 0
      case N n 
        return 1
      case ''
        return $default_return
    end 
  end 
end

function setup_git
  if ! read_confirm "Setup git?"
    return
  end

  install_package git
  
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

  install_package github-cli
end

function setup_neovim
  if ! read_confirm "Setup neovim?"
    return
  end
    
  install_package neovim

  set -l nvim_dir "$HOME/.config/nvim"
  set -l nvchad_repo "https://github.com/NvChad/NvChad"

  if test ! -e $nvim_dir
    git clone $nvchad_repo $nvim_dir --depth 1 && nvim
    backup_and_link $SCRIPT_DIR/nvim/custom $nvim_dir/lua/custom
  end 
end

function setup_kitty
  if ! read_confirm "Setup kitty?"
    return
  end
    
  install_package kitty

  backup_and_link $SCRIPT_DIR/kitty $HOME/.config/kitty
end

function setup_fish
  if ! read_confirm "Setup fish?"
    return
  end
    
  set -l fish_shell_passwd (grep -E $USER".*fish" /etc/passwd | string trim)
  if test -z $fish_shell_passwd
    chsh -s (which fish)
  end

  backup_and_link $SCRIPT_DIR/fish $HOME/.config/fish
end

function setup_fnm
  if ! read_confirm "Setup Fast Node Manager?"
    return
  end
    
  install_package fnm-bin
end

function setup_docker
  if ! read_confirm "Setup docker?"
    return
  end
    
  install_package docker
  install_package docker-compose

  if test -z (groups | grep docker)
    echo "Add" $USER "to group docker"
    sudo usermod -aG docker $USER
  end
end

function setup_rust
  if ! read_confirm "Setup rust?"
    return
  end
    
  if install_package rustup
    rustup default stable
    rustup component add rust-analyzer rust-src
  else
    rustup update
  end
end

function setup_unity
  if ! read_confirm "Setup Unity?"
    return
  end
  install_package unityhub

  # To support progressive lightmapper GPU
  install_package clinfo
  install_package ocl-icd
  install_package opencl-headers
  install_package opencl-nvidia

  # To support install of Android SDK
  install_package cpio

  # Other tools for scripting
  # install_package visual-studio-code-bin
  install_package dotnet-runtime
  install_package dotnet-sdk
  install_package mono-msbuild
  install_package mono
end

function setup_godot
  if ! read_confirm "Setup Godot?"
    return
  end
  
  install_package godot
  install_package godot-mono-bin
end

function setup_flutter
  if ! read_confirm "Setup Flutter?" n
    return
  end
  
  install_package fvm-bin

  install_package android-studio

  # For web build
  install_package google-chrome

  # For desktop support
  install_package clang
  install_package cmake
  install_package ninja
end

function setup_bluetooth
  if ! read_confirm "Setup bluetooth (needed for XFCE)?" n
    return
  end
  
  install_package bluez
  install_package bluez-utils
  install_package blueberry
end

function setup_keyboard_modifiers
  if ! read_confirm "Setup Keyboard Modifiers (for XFCE, not necessary in Gnome)?" n
    return
  end
  
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

function setup_starship
  if ! read_confirm "Setup Stasrship?"
    return
  end
  
  install_package starship
  backup_and_link $SCRIPT_DIR/starship.toml $HOME/.config/starship.toml
end

function setup_shell_themes
  if ! read_confirm "Setup Terminal Themes?"
    return
  end
  
  set -l themes_dir $HOME/.config/gruthemes
  if test ! -d $themes_dir
    git clone git@github.com:folke/tokyonight.nvim.git $themes_dir --depth 1 
  else
    git -C $themes_dir pull
  end
end

function setup_gaming
  if ! read_confirm "Setup Gaming?"
    return
  end
  # entertainment
  install_package steam
  # libraries for steam games: Loop Hero
  # install_package libldap24

  # install_package wine
  # install_package lutris
  if test ! -d "$HOME/.itch"
    echo "Setup itch.io"
    pushd "/tmp"
    curl -JLO "https://itch.io/app/download?platform=linux"
    chmod +x itch-setup && ./itch-setup
    rm itch-setup
    popd
  end
end

function setup_various
  if ! read_confirm "Setup Various?"
    return
  end
  flatpak install com.spotify.Client
  flatpak install net.ankiweb.shell
  flatpak install flathub com.discordapp.Discord
  flatpak install io.gitlab.azymohliad.WatchMate

  install_package newsflash
  install_package obsidian
  install_package foliate
  install_package shotwell
  install_package calibre
end

function setup_fonts
  if ! read_confirm "Setup fonts?"
    return
  end
  
  install_package ttf-nerd-fonts-symbols-common 
  install_package ttf-nerd-fonts-symbols-2048-em
  install_package xclip

  set -l font_path $HOME/.local/share/fonts/MonoLisa
  if test -e $font_path
    return
  end

  echo "setup MonoLisa font"
  while true
    read -p 'set_color green; echo -n "Path to monolisa font: "; set_color normal' -l path

    if test -e $path
      mkdir -p $font_path
      unzip -d $font_path $path
      return
    else
      echo 'Invalid MonoLisa path'
    end
  end 
end

# utilities
function setup_cli_utils
  if ! read_confirm "Setup cli utilities?"
    return
  end
  
  install_package ripgrep
  install_package fd
  install_package dua-cli
  install_package bottom
  install_package exa
end

# cloud
function setup_cloud
  if ! read_confirm "Setup cloud utilities?"
    return
  end
  
  install_package google-cloud-cli
  install_package google-cloud-cli-gke-gcloud-auth-plugin
  install_package kubectl
  install_package sops
  install_package aws-cli
  install_package helm
  install_package cmctl
end

function setup_python
  if ! read_confirm "Setup python dev tools?"
    return
  end
  
  install_package python-poetry
  install_package python-tox
  install_package pyenv
  install_package postgresql-libs
end

# For integration testing
function setup_integration_testing
  if ! read_confirm "Setup integration testing tools?" n
    return
  end
  
  install_package xorg-server-xvfb
  install_package google-chrome
  install_package chromedriver
end

# graphics and media
function setup_graphic
  if ! read_confirm "Setup graphic tooling?"
    return
  end
  
  install_package blender
  install_package gimp
  install_package inkscape
  install_package krita
  install_package simple-scan
  install_package evince
  install_package xf86-input-wacom
  install_package libwacom
  install_package pureref
  install_package perl-image-exiftool
  install_package jhead
  install_package optipng
  install_package pngquant
end

# Mega client
function setup_mega_sync
  if ! read_confirm "Setup MEGASync?"
    return
  end
  
  install_package megasync-bin
  install_package nautilus-megasync
end

# Gnome Extensions
function setup_gnome
  if ! read_confirm "Setup gnome?"
    return
  end

  install_package gnome-browser-connector
  install_package gnome-calendar

  backup_and_link $SCRIPT_DIR/slideshows/Wallpapers $HOME/Pictures/Wallpapers 
  backup_and_link $SCRIPT_DIR/slideshows/gnome-background-properties $HOME/.local/share/gnome-background-properties
end

setup_git
setup_neovim
setup_fish
setup_kitty
setup_shell_themes
setup_fnm

# game dev
setup_unity
setup_godot
setup_gaming

setup_fonts
setup_starship
setup_cli_utils
setup_cloud

# development
setup_docker
setup_python
setup_rust
setup_integration_testing

setup_mega_sync
setup_graphic
setup_various
setup_gnome

# Flutter
# setup_flutter
# Run `flutter doctor`
# Install Android SDK and SDK Commandline Tools
# Accept licenses `flutter doctor --android-licenses`

echo "Other Thing To Do:"
echo "- Sync Firefox account"
echo "- Install AppIndicator extension for Gnome"
echo "- Setup MonoLisa font"
echo "- Setup gnome online accounts"
