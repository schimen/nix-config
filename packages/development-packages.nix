pkgs: unstable: with pkgs; [
  # Python
  (python39.withPackages(ps: with ps; [
    aiohttp
    beautifulsoup4
    ipython
    ipykernel
    notebook
    matplotlib
    numpy
    sympy
    pandas
    requests
    tkinter
    west # zephyr python package
    pyelftools
    pyserial
  ]))

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
  ]))

  # Tools
  vscode-fhs
  direnv
  qemu
  qtemu
  socat
  bat
  fd
  xclip

  # Embedded
  cutecom
  arduino
  openocd
  teensy-loader-cli
  dtc
  # Avr
  pkgsCross.avr.avrlibc
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
