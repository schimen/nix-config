{ config, pkgs, ... }:

{
  users.users.jamila = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" ];
    packages = with pkgs; [
      google-chrome
    ];
  };

  home-manager.users.jamila = {
    home.stateVersion = "22.11";
    home.keyboard.layout = "no";
    programs.home-manager.enable = true;
  };

  services.desktopManager.gnome.enable = true;
}
