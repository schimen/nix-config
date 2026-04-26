pkgs: unstable: 
with pkgs; [
  # Python
  (python3.withPackages(ps: with ps; [
    aiohttp
    aiofiles
    beautifulsoup4
    cython
    geopandas
    gphoto2
    ipykernel
    jupyterlab
    matplotlib
    numpy
    opencv4
    openpyxl
    pandas
    pyqt5
    pyqt6
    psycopg2
    requests
    scikit-image
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
  socat
  arp-scan
  bat
  fd
  xorg.xhost
  pandoc
  texliveSmall
  plantuml
  graphviz
  jre8
  ffmpeg
  p7zip
  zerotierone
  heroku
  postgresql
  net-tools
  opencode

  # Embedded
  picocom
  pulseview
  arduino
  openocd
  dtc
  rpi-imager

  # C/C++
  cmake
  clang
  clang-tools
  gcc
  gcc-arm-embedded
  gnumake
  ncurses
  ninja
  opencv
]
