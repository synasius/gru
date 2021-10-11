#!/usr/bin/env fish

set -l script_dir (realpath (dirname (status -f)))

function read_confirm --description 'Ask the user for confirmation' --argument prompt
  if test -z "$prompt"
    set prompt "Continue?"
  end

  while true
    read -p 'set_color green; echo -n "$prompt [y/N/q]: "; set_color normal' -l confirm

    switch $confirm
      case Y y
        return 0
      case '' N n
        return 1
      case q Q
        exit 0
    end
  end
end


function backup_and_link -d 'Link file or directory and create backup when directory exitsts' -a source dest

  if test -e $dest && test ! -L $dest
    echo "Backup directory at $dest"
    mv $dest $dest.bkp
  end
  if test ! -L $dest
    ln -s $source $dest
  else
    echo "Link at $dest already exists"
  end
end


if read_confirm "Linking dotfiles and configurations"
  backup_and_link $script_dir/fish $HOME/.config/fish
  backup_and_link $script_dir/kitty $HOME/.config/kitty
  backup_and_link $script_dir/nvim $HOME/.config/nvim
  backup_and_link $script_dir/.gitconfig.local $HOME/.gitconfig.local
end


if read_confirm "Install/Upgrade packages from apt"
  begin
    set --local ppa_repositories \
      ppa:appimagelauncher-team/stable \
      ppa:fish-shell/release-3 \
      ppa:neovim-ppa/unstable

    for ppa in $ppa_repositories
      sudo add-apt-repository $ppa -n -y
    end

    sudo apt update && sudo apt upgrade
    sudo apt autoremove

    set --local apt_packages \
      appimagelauncher \
      apt-transport-https \
      build-essential \
      curl \
      ca-certificates \
      docker.io \
      docker-compose \
      git \
      git-lfs \
      gnupg \
      golang \
      libpq-dev \
      make \
      mesa-utils \
      neovim \
      python3-dev \
      python3-venv \
      python3-virtualenv \
      postgresql-client \
      ripgrep \
      steam \
      tree \
      vulkan-tools \
      xclip \
      xvfb

    sudo apt install $apt_packages
  end
end


if read_confirm "Run docker setup"
  sudo usermod -aG docker $USER
end


if read_confirm "Run fish setup"
  # Download fish completion since `kubectl` does not export completion for Fish
  curl -sLo $HOME/.config/fish/completions/kubectl.fish https://raw.githubusercontent.com/evanlucas/fish-kubectl-completions/main/completions/kubectl.fish
end


if read_confirm "Install packages from snap"
  sudo snap install spotify
  sudo snap install discord
  sudo snap install helm --classic
end


if read_confirm "Setup Google Cloud SDK and tools"
  if test ! -f /etc/apt/sources.list.d/google-cloud-sdk.list
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt update
    sudo apt install google-cloud-sdk kubectl
  end
end


if read_confirm "Install Unity dev environment"
  sudo snap install code --classic

  sudo snap install dotnet-sdk --classic --channel=lts/stable
  sudo snap alias dotnet-sdk.dotnet dotnet
  sudo ln -s /snap/dotnet-sdk/current/dotnet /usr/local/bin/dotnet

  sudo apt install gnupg ca-certificates
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
  echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
  sudo apt update
  sudo apt install mono-complete
end


if read_confirm "Install/Upgrade Kitty"
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
  if test ! -L ~/.local/bin/kitty
    # Create a symbolic link to add kitty to PATH (assuming ~/.local/bin is in
    # your PATH)
    ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
    # Place the kitty.desktop file somewhere it can be found by the OS
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    # Update the path to the kitty icon in the kitty.desktop file
    sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop

    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator ~/.local/bin/kitty 50
  end
end


if read_confirm "Install/Upgrade Starship"
  sh -c (curl -fsSL https://starship.rs/install.sh | string collect) -- --yes
  starship completions fish > $HOME/.config/fish/completions/starship.fish
end


if read_confirm "Install/Upgrade FNM"
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  fnm completions --shell fish > $HOME/.config/fish/completions/fnm.fish
end


if read_confirm "Install/Upgrade pyenv"
  if type -q pyenv
    echo Upgrade pyenv
    pyenv update
  else
    echo Install Pyenv
    curl https://pyenv.run | bash

    sudo apt-get update; sudo apt-get install libssl-dev zlib1g-dev \
      libbz2-dev libreadline-dev libsqlite3-dev llvm \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
  end
end


if read_confirm "Install/Upgrade poetry"
  if type -q poetry
    poetry self update
  else
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python3 - --version=1.1.11
  end
  $HOME/.local/bin/poetry completions fish > $HOME/.config/fish/completions/poetry.fish
end


if read_confirm "Install/Upgrade tox"
  if test ! -d $HOME/.tox
    python3 -m venv $HOME/.tox
  end
  source $HOME/.tox/bin/activate.fish
  pip install --upgrade tox
  deactivate
end


if read_confirm "Install/Upgrade Nerd Fonts"
  begin
    set --local nerd_font_base_url "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/"
    set --local nerd_fonts_to_download \
      "Bold/complete/Fira%20Code%20Bold%20Nerd%20Font%20Complete.ttf" \
      "Medium/complete/Fira%20Code%20Medium%20Nerd%20Font%20Complete.ttf" \
      "Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf" \
      "SemiBold/complete/Fira%20Code%20SemiBold%20Nerd%20Font%20Complete.ttf" \
      "Retina/complete/Fira%20Code%20Retina%20Nerd%20Font%20Complete.ttf"

    mkdir -p $HOME/.local/share/fonts/NerdFonts

    if test -d /tmp/NerdFonts
      rm -rf /tmp/NerdFonts
    end

    mkdir -p /tmp/NerdFonts
    cd /tmp/NerdFonts

    for font in $nerd_fonts_to_download
      curl -LO $nerd_font_base_url$font
    end

    cp /tmp/NerdFonts/*.ttf $HOME/.local/share/fonts/NerdFonts

    if test -d /tmp/NerdFonts
      rm -rf /tmp/NerdFonts
    end
  end
end


if read_confirm "Install/Upgrade Rust"
  if type -q rustup
    rustup self update
    rustup update stable
  else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
  end
end


if read_confirm "Install Brave Browser"
  sudo apt install apt-transport-https curl

  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

  sudo apt update

  sudo apt install brave-browser
end
