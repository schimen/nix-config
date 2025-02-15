pkgs: unstable: 
with pkgs; [
  # Python
  (python3.withPackages(ps: with ps; [
    aiohttp
    aiofiles
    beautifulsoup4
    ipykernel
    jupyterlab
    matplotlib
    numpy
    scikit-learn
    pandas
    openpyxl
    pydub
    sympy
    scipy
    requests
    tkinter
    gphoto2
    opencv4
  ] ++ (import ./west-packages.nix ps)
  ))

  nodejs

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
  cutecom
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
