pkgs: unstable: with pkgs; [
  # Apps
  firefox
  thunderbird
  spotify
  # Social
  unstable.discord
  unstable.teams
  slack
  signal-desktop
  unstable.zoom-us
  # School (tools)
  todoist-electron
  libreoffice
  gnuradio
  texlive.combined.scheme-basic
  gummi
  zotero
  kicad
  drawio
  unstable.obsidian
  qalculate-gtk
  geogebra6
  # Other tools
  borgbackup
  freecad
  blender
  audacity
  povray # Render for freecad
  cura
  darktable
  gimp-with-plugins
  transmission-gtk
  realvnc-vnc-viewer
  # Entertainment
  vlc
  gnome-network-displays
  minecraft
  unstable.optifine
  (callPackage ./pinball {})
  calibre
  # Wine for windows applications:
  wine
]
