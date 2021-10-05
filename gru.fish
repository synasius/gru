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
      build-essential \
      curl \
      docker.io \
      docker-compose \
      git \
      git-lfs \
      make \
      neovim \
      python3-dev \
      python3-venv \
      python3-virtualenv \
      postgresql-client \
      ripgrep \
      steam \
      tree \
      xclip \
      xvfb

    sudo apt install $apt_packages
  end
end


if read_confirm "Run fish setup"
  # Download fish completion since `kubectl` does not export completion for Fish
  curl -sLo $HOME/.config/fish/completions/kubectl.fish https://raw.githubusercontent.com/evanlucas/fish-kubectl-completions/main/completions/kubectl.fish
end


if read_confirm "Install packages from snap"
  snap install spotify

  snap install google-cloud-sdk --classic
  sudo snap alias google-cloud-sdk.kubectl kubectl

  snap install helm --classic
end


if read_confirm "Install Unity dev environment"
  snap install code --classic

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
  end
end


if read_confirm "Install/Upgrade poetry"
  if type -q poetry
    poetry self update
  else
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python3 - --version=1.1.10
  end
  poetry completions fish > $HOME/.config/fish/completions/poetry.fish
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
      rm -f /tmp/NerdFonts
    end

    mkdir -p /tmp/NerdFonts
    cd /tmp/NerdFonts

    for font in $nerd_fonts_to_download
      curl -LO $nerd_font_base_url$font
    end

    cp /tmp/NerdFonts/*.ttf $HOME/.local/share/fonts/NerdFonts

    if test -d /tmp/NerdFonts
      rm -f /tmp/NerdFonts
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
