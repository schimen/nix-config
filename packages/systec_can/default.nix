{ lib, stdenv, fetchurl, kernel, kmod }:

let
  pname = "systec_can";
  version = "1.0.6";
in
stdenv.mkDerivation {
  inherit version pname;

  src = fetchurl rec {
    url = "https://www.systec-electronic.com/media/default/Redakteur/Unternehmen/Support/Downloadbereich/Treiber/${pname}-v${version}.tar.bz2";
    sha256 = "0fa8cyma4svp2z27fynw0g75bag3kp206fn3g75wnjyzwq4c048m";
  };

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "FW_DIR=$(out)/lib/firmware"
    "INSTALL_MOD_PATH=$(out)"
  ];

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [ kmod ];

  preConfigure = ''
    substituteInPlace ./Makefile \
      --replace 'depmod'         \
                'depmod -b ${kernel}'
  '';

  postInstall = ''
    # Make sure install .ko file to module directory
    mkdir -p $out/lib/modules/${kernel.modDirVersion}
    install --mode=644 ./*.ko $out/lib/modules/${kernel.modDirVersion}
  '';
}
