pkgs: unstable: 
with pkgs; [
  # Python
  (python3.withPackages(ps: with ps; [
    aiohttp
    aiofiles
    beautifulsoup4
    ipykernel
    matplotlib
    numpy
    pandas
    pydub
    sympy
    scipy
    requests
    tkinter
  ] ++ (import ./west-packages.nix ps)
  ))

  # Haskell
  (ghc.withPackages(hp: with hp; [
    random
    xmonad
    xmonad-extras
    haskell-language-server
  ]))

  # Tools
  vscode-fhs
  vim
  direnv
  qemu
  teamviewer
  ngrok
  virt-manager
  socat
  bat
  fd
  xclip
  pandoc
  ffmpeg
  p7zip
  git-cola
  kdiff3

  # Embedded
  cutecom
  pulseview
  arduino
  openocd
  teensy-loader-cli
  dtc
  # nRF
  nrfutil
  nrf5-sdk
  # Avr
  pkgsCross.avr.buildPackages.binutils
  pkgsCross.avr.buildPackages.gcc
  avrdude

  # C/C++
  gcc
  gcc-arm-embedded
  gnumake
  unstable.cmake
  ninja
  clang
  clang-tools
]
