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


install_package optimus-manager
install_package optimus-manager-qt

# TODO:  nvidia-installer-dkms

install_package nerd-fonts-fira-code
install_package starship
install_package xclip

# utilities
install_package ripgrep
install_package fd
install_package pngquant
install_package dua-cli
install_package bottom

setup_git
setup_neovim

setup_fish
setup_kitty

setup_fnm
