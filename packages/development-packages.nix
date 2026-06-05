pkgs: unstable: 
with pkgs; [
  # Python
  (python3.withPackages(ps: with ps; [
    aiofiles
    aiohttp
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
    psycopg2
    pyqt5
    pyqt6
    requests
    scikit-image
    scikit-learn
    scipy
    sympy
    tkinter
  ] ++ (import ./west-packages.nix ps)
  ))

  # Tools
  arp-scan
  bat
  direnv
  dnsmasq
  fd
  ffmpeg
  graphviz
  heroku
  jre8
  net-tools
  opencode
  p7zip
  pandoc
  plantuml
  postgresql
  socat
  texliveSmall
  vim
  vscode-fhs
  xhost
  zerotierone
  wireshark

  # Embedded
  arduino
  dtc
  openocd
  picocom
  pulseview
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
  readline
  spdlog
]
