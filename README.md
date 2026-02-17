# gru
A script to setup/update/manage packages, configurations and dotfiles

### Stow usage

Assuming this repo is cloned in the user home:

```
# if repo is cloned in $HOME/.gru
stow --dotfiles -S bash -v

# otherwise
stow --dotfiles -S -t $HOME bash -v
```
