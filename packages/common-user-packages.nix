pkgs: with pkgs; [
  # Tools
  transmission-gtk
  qalculate-gtk
  cutecom
  gnuradio
  texlive.combined.scheme-full
  gummi
  arduino

  # Apps
  firefox
  vlc
  discord
  teams
  slack
  obsidian
  libreoffice
  gimp
  thunderbird
  zoom-us
  spotify
  kicad
  freecad
  minecraft
  cura
  drawio
  musescore
  (callPackage ./geogebra {})   # geogebra 6
  (callPackage ./nrfconnect {}) # nRF Connect
  (callPackage ./notion {})     # Notion
]
