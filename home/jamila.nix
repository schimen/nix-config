{ config, pkgs, ... }:
let
  commonUserPackages  = import ../packages/common-user-packages.nix pkgs;
in
{
  users.users.jamila = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" ];
  };

  home-manager.users.jamila = {
    home.keyboard.layout = "no";
    programs.home-manager.enable = true;
  };

  services.xserver.desktopManager.gnome.enable = true;
}
