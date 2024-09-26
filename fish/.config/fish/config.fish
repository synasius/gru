if status is-interactive

    if type -q pyenv
        # Initialize pyenv
        pyenv init - | source
    end

    if type -q fnm
        # Initialize Fast Node Manager
        fnm env --use-on-cd --shell fish | source
    end

    if type -q starship
        # starship
        starship init fish | source
    end

end
