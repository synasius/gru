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
