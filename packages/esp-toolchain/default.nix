{ stdenv, lib, fetchurl, pkgs,
  platform ? "linux",
  arch ? "amd64",
  compiler ? "gcc",
  compilerVersion ? "11_2_0",
  releaseName ? "esp-2022r1-RC1",
  toolchainName ? "xtensa-esp32-elf",
  srcSHA256 ? "5da31dfe66ee97c0e940d81e7fac3fc604bb4cbf75294a29e6d5384ae08102dc"
}:

stdenv.mkDerivation {
  name = toolchainName;
  src = fetchurl {
    url = "https://github.com/espressif/crosstool-NG/releases/download/${releaseName}/${toolchainName}-${compiler}${compilerVersion}-${releaseName}-${platform}-${arch}.tar.xz";
    sha256 = srcSHA256;
  };

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
    mkdir -p $out/${toolchainName}
    cp -r * $out/${toolchainName}
  '';
}
