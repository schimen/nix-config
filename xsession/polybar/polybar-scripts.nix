{ stdenv, lib, pkgs }:

stdenv.mkDerivation rec {
  pname = "polybar-scripts";
  version = "1.0.0";
  meta = with lib; {
    description = "Shell scripts for polybar";
    longDescription = ''
      Scripts for script modules in polybar.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ "schimen" ];
  };
  src = ./scripts;
  phases = "installPhase fixupPhase";
  installPhase = ''
    echo "starting"
    ls ${src}

    mkdir -p $out/bin
    cp ${src}/* $out/bin/
    chmod +x $out/bin/*
  '';
}

