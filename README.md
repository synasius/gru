# gru
A script to setup/update/manage packages, configurations and dotfiles

## Usage

First install `fish` shell and NVIDIA Drivers and reboot

    yay -S fish
    sudo nvidia-installer-dkms

    sudo systemctl reboot

Now from a `fish` shell run:

    ./gru.fish
