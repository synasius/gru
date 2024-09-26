#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

PS1='[\u@\h \W]\$ '

if command -v pyenv >/dev/null 2>&1; then

  # Pyenv configuration
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"

fi

if command -v fnm >/dev/null 2>&1; then

  # Fast Node Manager setup
  eval "$(fnm env --use-on-cd --shell bash)"

fi

if command -v starship >/dev/null 2>&1; then

  # Init starship
  eval "$(starship init bash)"

fi
