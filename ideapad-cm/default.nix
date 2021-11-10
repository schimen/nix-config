{ stdenv, fetchurl, lib }:

let
  repoUrl = "https://raw.githubusercontent.com/tildehacker/ideapad-conservation-mode";
  commit = "71b4083cfa9b9b2264389de2a77cdf8b208497cd";
in

stdenv.mkDerivation rec {
  pname = "ideapad-cm";
  version = "1.0.0";

  meta = with lib; {
      description = "Shell script for controlling consevation mode";
      longDescription = ''
        Script for enabling, disabling and getting status of batteyr conservation mode in lenovo laptops.
      '';
      homepage = "https://github.com/tildehacker/ideapad-conservation-mode";
      license = licenses.gpl3Plus;
      platforms = platforms.all;
      maintainers = [ "schimen" ];
  };
  src = fetchurl {
    url = "${repoUrl}/${commit}/ideapad-cm";
    sha256 = "3abdded5b2ebc7710a92a7ce203267b615fd871c24d0f4149ef1c779dd0b1927";
  };
  phases = "installPhase fixupPhase";
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/ideapad-cm
    chmod +x $out/bin/ideapad-cm
  '';
}
