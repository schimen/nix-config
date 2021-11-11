pkgs: with pkgs; [
  # Tools
  vim
  wget
  curl
  unzip
  nomacs
  mupdf
  vscodium
  gnome.gnome-disk-utility
  gnome.file-roller
  usbutils
  direnv
  
  # System
  xfce.xfce4-whiskermenu-plugin
  lightlocker
  brightnessctl
  dmenu
  wineWowPackages.stable
  neofetch
  pulseeffects-legacy
  system-config-printer
  wmname
  
  # Themes
  papirus-icon-theme
  dracula-theme
  
  # Programming languages
  (python3.withPackages(ps: with ps; [
    aiohttp
    beautifulsoup4
    ipython
    ipykernel
    matplotlib
    numpy
    sympy
    pandas
    requests
    tkinter
  ]))
]
