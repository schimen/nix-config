{ config, pkgs, ... }:

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

  environment.systemPackages = with pkgs; [
    google-chrome
  ];
}
