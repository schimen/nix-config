pkgs: unstable: 
with pkgs; [
  # Python
  (python3.withPackages(ps: with ps; [
    aiohttp
    aiofiles
    beautifulsoup4
    cython
    gphoto2
    ipykernel
    jupyterlab
    matplotlib
    numpy
    opencv4
    openpyxl
    pandas
    psycopg2
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
  net-tools

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
