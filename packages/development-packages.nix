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
  ffmpeg
  p7zip

  # Embedded
  cutecom
  pulseview
  arduino
  openocd
  dtc

  # C/C++
  gcc
  gcc-arm-embedded
  gnumake
  cmake
  ninja
  clang
  clang-tools
]
