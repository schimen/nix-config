pkgs: unstable: with pkgs; [
  # Apps
  firefox
  thunderbird
  spotify
  # Social
  discord
  teams-for-linux
  slack
  signal-desktop
  zoom-us
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
  (callPackage ./openconnect-sso {}) # program to make ntnu vpn work
  # Other tools
  borgbackup
  freecad
  blender
  audacity
  reaper
  povray # Render for freecad
  cura
  darktable
  gimp-with-plugins
  krita
  transmission-gtk
  realvnc-vnc-viewer
  # Entertainment
  vlc
  gnome-network-displays
  minecraft
  optifine
  calibre
  # Wine for windows applications:
  wineWowPackages.stable
]
