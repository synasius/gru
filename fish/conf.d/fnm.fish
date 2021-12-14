fish_add_path $HOME/.fnm

if type -q fnm
  fnm env | source
end
