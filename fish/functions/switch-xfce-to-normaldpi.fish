function switch-xfce-to-normaldpi
  xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s 1
  xfconf-query -c xfwm4 -p /general/theme -s Arc-Darker
end
