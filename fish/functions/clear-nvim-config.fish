function clear-nvim-config --description 'clear nvim config' -a remove_config
  echo "Removing ~/.local/share/nvim"
  rm -rf ~/.local/share/nvim
  echo "Removing ~/.cache/nvim"
  rm -rf ~/.cache/nvim


  if test -n $remove_config
    set -l nvim_config_dir "~/.config/nvim"

    if test -L $nvim_config_dir
      echo "Unlink $nvim_config_dir"
      unlink $nvim_config_dir
    end

    if test -d $nvim_config_dir
      echo "Remove $nvim_config_dir"
      rm -rf $nvim_config_dir
    end
  end
end
