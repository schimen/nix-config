with import <nixpkgs> { };
rec {
  notion = pkgs.callPackage ./systec_can.nix { kernel=pkgs.linux_5_10; };
}
