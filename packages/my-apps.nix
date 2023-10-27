pkgs: unstable: with pkgs; [
  # Apps
  firefox
  thunderbird
  spotify
  # Social
  unstable.discord
  teams
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
  (callPackage ./packages/openconnect-sso {}) # program to make ntnu vpn work
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
  unstable.optifine
  (callPackage ./pinball {})
  calibre
  # Wine for windows applications:
  wineWowPackages.stable
]
