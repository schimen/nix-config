pkgs: unstable: with pkgs; [
  # Apps
  firefox
  thunderbird
  spotify
  # Social
  discord
  teams
  slack
  zoom-us
  # School (tools)
  libreoffice
  gnuradio
  texlive.combined.scheme-basic
  gummi
  kicad
  drawio
  obsidian
  qalculate-gtk
  geogebra6
  #(callPackage ./notion   {}) # Notion
  # Other tools
  freecad
  cura
  gimp-with-plugins
  transmission-gtk
  musescore
  # Entertainment
  vlc
  gnomecast
  minecraft
  unstable.optifine
  (callPackage ./pinball {})
  sgtpuzzles
  # Wine for windows applications:
  wineWowPackages.stable
  # Virtualbox for windows
  virtualbox
]
