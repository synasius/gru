function switch-xfce-to-hidpi
  xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s 2
  xfconf-query -c xfwm4 -p /general/theme -s Arc-Darker-hdpi
end
