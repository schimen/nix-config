{ appimageTools
, lib
, fetchurl
# dependencies:
, git
, wget
, ncurses5
, cmake
, ninja
, gperf
, ccache
, dfu-util
, dtc
, file
, gnumake
}:

let
  pname = "nrfconnect";
  version = "3.9.0";
  versionDashed = with lib; replaceStrings ["."] ["-"] version;
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-connect-for-desktop/${versionDashed}/${name}-x86_64.appimage";
    sha256 = "096y4lrc56pbwjfyrw3am57nbbx8qkf95nmqc0hxkpd2qql8anpy";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop \
      $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/${pname}.png \
      $out/share/icons/hicolor/0x0/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}' \
  '';
  meta = with lib; {
    description = "Cross-platform tool framework for assisting development on nRF devices.";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Connect-for-desktop";
    license = licenses.unfree;
    maintainers = with maintainers; [ "schimen" ];
    platforms = [ "x86_64-linux" ];
  };
}
