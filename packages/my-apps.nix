pkgs: with pkgs; [
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
  (callPackage ./notion   {})   # Notion
  (callPackage ./geogebra {})   # geogebra 6
  # Other tools
  freecad
  cura
  gimp
  transmission-gtk
  musescore
  # Entertainment
  vlc
  minecraft
  # Wine for windows applications:
  wineWowPackages.stable
]
