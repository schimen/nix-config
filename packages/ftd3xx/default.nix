{ stdenv, lib, fetchurl, autoPatchelfHook}:

stdenv.mkDerivation rec {
  pname = "libftd3xx";
  version = "1.1.5";

  src = fetchurl {
    url = "https://ftdichip.com/wp-content/uploads/2026/03/libftd3xx-linux-${stdenv.buildPlatform.linuxArch}-${version}.tgz";
    hash = "sha256-+DLzj5EWR/iSmOLhMrjMACXiVRaSFqfr8UnwwHlh6LM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''                                                                    
    mkdir -p $out/lib $out/include/ftd3xx
    cp Types.h ftd3xx.h $out/include/ftd3xx/
    install -m 0755 libftd3xx.so.${version} $out/lib/
    ln -s libftd3xx.so.${version} $out/lib/libftd3xx.so
  '';                   

  meta = with lib; {
    homepage = "https://ftdichip.com/drivers/d3xx-drivers/";
    description = "FTDI USB driver for SuperSpeed USB ICs such as the FT60x.";
    platforms = platforms.linux;
  };
}
