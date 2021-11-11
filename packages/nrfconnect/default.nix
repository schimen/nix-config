{ appimageTools, lib, fetchurl }:

let
  pname = "nrfconnect";
  version = "3.8.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-connect-for-desktop/${version}/${name}-x86_64.appimage";
    sha256 = "0y110ib96a3ij6084929120gc5r3b0sjkpgcn3jy8pn8k7q76vam";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop \
      $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';
  meta = with lib; {
    description = "Cross-platform tool framework for assisting development on nRF devices.";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Connect-for-desktop";
    license = licenses.unfree;
    maintainers = with maintainers; [ "schimen" ];
    platforms = [ "x86_64-linux" ];
  };
}
