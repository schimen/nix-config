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
    JuicyPixels
    random
    repa
    JuicyPixels-repa
    hmatrix
    vector-algorithms
    xmonad
    xmonad-extras
    matplotlib
    haskell-language-server
  ]))

  # Tools
  vscode-fhs
  direnv
  qemu
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
  nrf-command-line-tools
  nrfconnect
  nrfutil
  nrf5-sdk
  segger-jlink
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
