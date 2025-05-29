pkgs: unstable: 
with pkgs; [
  # Python
  (python3.withPackages(ps: with ps; [
    aiohttp
    aiofiles
    beautifulsoup4
    gphoto2
    ipykernel
    jupyterlab
    matplotlib
    numpy
    opencv4
    openpyxl
    pandas
    requests
    scikit-learn
    scipy
    sympy
    tkinter
  ] ++ (import ./west-packages.nix ps)
  ))

  # Tools
  vscode-fhs
  vim
  direnv
  teamviewer
  socat
  arp-scan
  bat
  fd
  xclip
  xorg.xhost
  pandoc
  texliveSmall
  plantuml
  ffmpeg
  p7zip
  ngrok
  zerotierone
  heroku
  postgresql

  # Embedded
  picocom
  pulseview
  arduino
  openocd
  dtc
  rpi-imager

  # C/C++
  gcc
  gcc-arm-embedded
  gnumake
  cmake
  ninja
  clang
  clang-tools
]
