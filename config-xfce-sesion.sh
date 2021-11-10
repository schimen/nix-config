xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -t string -sa xmonad
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client1_Command -t string -s xfsettingsd -t string -s --disable-wm-check
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client2_Command -t string -s xfce4-panel -t string -s --disable-wm-check
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client3_Command -t string -s thunar      -t string -s --daemon
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client4_Command -t string -sa empty
