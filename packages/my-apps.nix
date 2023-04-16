pkgs: unstable: with pkgs; [
  # Apps
  firefox
  thunderbird
  spotify
  # Social
  unstable.discord
  unstable.teams
  slack
  element-desktop
  unstable.zoom-us
  # School (tools)
  todoist-electron
  libreoffice
  gnuradio
  texlive.combined.scheme-basic
  gummi
  kicad
  drawio
  unstable.obsidian
  qalculate-gtk
  geogebra6
  # Other tools
  borgbackup
  freecad
  reaper
  audacity
  povray # Render for freecad
  cura
  darktable
  gimp-with-plugins
  transmission-gtk
  musescore
  realvnc-vnc-viewer
  # Entertainment
  vlc
  gnome-network-displays
  gnomecast
  minecraft
  unstable.optifine
  (callPackage ./pinball {})
  sgtpuzzles
  calibre
  # Wine for windows applications:
  wineWowPackages.full
  winetricks
]
