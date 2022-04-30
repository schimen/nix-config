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
  #(callPackage ./geogebra {}) # geogebra 6
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
  (callPackage ./pinball {}) # Optifine with my version
  sgtpuzzles
  # Wine for windows applications:
  wineWowPackages.stable
  # Virtualbox for windows
  virtualbox
]
