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
