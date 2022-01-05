function replace_version -a old new
  rg -F $old -l | xargs sed -i 's/'$old'/'$new'/g'
end
