if status is-interactive
    # Initialize pyenv
    pyenv init - | source

    # Initialize Fast Node Manager
    fnm env --use-on-cd --shell fish | source

    # starship
    starship init fish | source
end
