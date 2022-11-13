pkgs: unstable: with pkgs; [
  # Apps
  firefox
  thunderbird
  spotify
  # Social
  unstable.discord
  unstable.teams
  slack
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
  unstable.geogebra6
  #(callPackage ./notion   {}) # Notion
  # Other tools
  freecad
  povray # Render for freecad
  cura
  darktable
  gimp-with-plugins
  transmission-gtk
  musescore
  realvnc-vnc-viewer
  # Entertainment
  vlc
  gnomecast
  minecraft
  unstable.optifine
  (callPackage ./pinball {})
  sgtpuzzles
  calibre
  # Wine for windows applications:
  wineWowPackages.stable
  # Virtualbox for windows
  virtualbox
]
