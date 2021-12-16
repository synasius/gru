if type -q pyenv
  status is-interactive; and pyenv init - | source
  pyenv init --path | source
end
