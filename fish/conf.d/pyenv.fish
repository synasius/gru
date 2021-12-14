set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

if type -q pyenv
  status is-interactive; and pyenv init - | source
  pyenv init --path | source
end
