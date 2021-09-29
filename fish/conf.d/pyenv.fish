set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

status is-interactive; and pyenv init - | source
pyenv init --path | source
