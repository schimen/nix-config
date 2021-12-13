{ stdenv, lib, playerctl }:

stdenv.mkDerivation rec {
  pname = "mpris-script-polybar";
  version = "1.0.0";
  inherit playerctl;
  meta = with lib; {
      description = "Shell script for displaying music player information";
      longDescription = ''
        Script that uses playerctl to retrieve music player information. Used in personal polybar.
      '';
      license = licenses.gpl3Plus;
      platforms = platforms.all;
      maintainers = [ "schimen" ];
  };
  src = ./mpris-script.sh;
  phases = "installPhase fixupPhase";
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/mpris-script
    chmod +x $out/bin/mpris-script
  '';
}
