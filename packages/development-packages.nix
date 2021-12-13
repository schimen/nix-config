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
    vector-algorithms
  ]))

  # Tools
  neovim
  vscodium
  unzip
  direnv

  # Embedded
  (callPackage ./nrfjprog {})           # nrfjprog
  (callPackage ./nrfconnect {})         # nRF Connect
  cutecom
  arduino
  avrdude
  openocd
  dtc

  # C/C++
  gcc
  gcc-arm-embedded
  gnumake
  unstable.cmake
  ninja
]
