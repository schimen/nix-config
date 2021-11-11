{ stdenv, lib, buildFHSUserEnv, autoPatchelfHook, unzip, dpkg, gtk3,
  cairo, glib, webkitgtk, libusb1, bash, libsecret, alsaLib,
  bzip2, openssl, libudev, ncurses5, tlf, xorg, fontconfig, pcsclite, python27,
  requireFile
}:
let
  makeself-pkg = stdenv.mkDerivation {
    name = "stm32cubeide-makeself-pkg";
    # Direct download URL is probably not available, because one has
    # to agree to the license.
    src = requireFile rec {
      name = "en.st-stm32cubeide_1.7.0_10852_20210715_0634_amd64.sh_v1.7.0.zip";
      sha256 = "1qasp1gxcf16c9cg5miph6phxc5k80bagabdqihskgiccmwgpqmz";
      url = "https://www.st.com/en/development-tools/stm32cubeide.html";
    };
    unpackCmd = "mkdir tmp && ${unzip}/bin/unzip -d tmp $curSrc";
    installPhase = ''
      sh st-stm32cubeide_1.7.0_10852_20210715_0634_amd64.sh --target $out --noexec
    '';
  };
  stm32cubeide = stdenv.mkDerivation {
    name = "stm32cubeide";
    version = "1.7.0";
    src = "${makeself-pkg}/st-stm32cubeide_1.7.0_10852_20210715_0634_amd64.tar.gz";
    dontUnpack = true;
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      stdenv.cc.cc.lib # libstdc++.so.6
      libsecret
      alsaLib
      bzip2
      openssl
      libudev
      ncurses5
      tlf
      fontconfig
      pcsclite
      python27
    ] ++ (with xorg; [
      libX11
      libSM
      libICE
      libXrender
      libXrandr
      libXfixes
      libXcursor
      libXext
      libXtst
      libXi
    ]);
    autoPatchelfIgnoreMissingDeps = true; # libcrypto.so.1.0.0
    preferLocalBuild = true;
    installPhase = ''
      mkdir -p $out
      tar zxf $src -C $out
#       mkdir -p $out/bin
#       ln -s $out/opt/st/stm32cubeide_1.7.0/stm32cubeide $out/bin
    '';
  };
  stlink-server = stdenv.mkDerivation {
    name = "stlink-server-2.0.2-3";
    src = "${makeself-pkg}/st-stlink-server.2.0.2-3-linux-amd64.install.sh";
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ libusb1 ];
    unpackCmd = "sh $src --target dir --noexec";

    installPhase = ''
      ls -lR
      mkdir -p $out/bin
      cp stlink-server $out/bin
    '';
  };
in
# We use FHS environment because we want to run the compilers
# downloaded from the IDE and it is also needed by bundled SWT libraries.
buildFHSUserEnv {
  name = "stm32cubeide";

  targetPkgs = pkgs: with pkgs; [
    stm32cubeide
    gtk3 cairo glib webkitgtk

    # These libraries are also needed in the FHS environment for
    # flashing/debugging to work. Having them as dependencies in
    # stm32cubeide is not sufficient.
    stdenv.cc.cc.lib # libstdc++.so.6
    libsecret
    alsaLib
    bzip2
    openssl
    libudev
    ncurses5
    tlf
    fontconfig
    pcsclite
    python27

    stlink-server
    ncurses5
  ];

  runScript = ''
    ${stm32cubeide}/stm32cubeide
  '';
}
