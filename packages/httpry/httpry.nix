{ stdenv, lib, fetchurl, pkgs }:

stdenv.mkDerivation rec {
  name = "httpry";
  src = fetchurl {
    url = "https://github.com/jbittel/httpry/archive/refs/heads/master.zip";
    sha256 = "0cjw05grfp3rz2hb9z6sd34f7zrlhrd8mgmm3pk1m7658z64yhsc";
  };
  buildInputs = with pkgs; [
    unzip
    libpcap
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp -f httpry $out/bin
  '';
}
