{ stdenv, lib, fetchurl, pkgs }:

let
  arch = "amd64";
  gccVersion = "8_4_0";
  src = fetchurl {
    url = "https://dl.espressif.com/dl/xtensa-esp32-elf-gcc${gccVersion}-esp-2020r3-linux-${arch}.tar.gz";
    sha256 = "0ycj9rbmpwl6vwrn4hfn0vxnvzpgx9nirraw79dbwplw5yhq0h37";
  };
in
  stdenv.mkDerivation {
    name = "xtensa-esp32-elf";
    inherit src;

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
    ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      python27Full
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/xtensa-esp32-elf
      cp -r *  $out/xtensa-esp32-elf
    '';
  }
