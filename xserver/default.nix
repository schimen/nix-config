{ config, pkgs, ... }:
let 
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
    sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
  };
in
{
  imports = [ ./xmonad ];
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    #Configure keymap in X11
    layout = "no";

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
      
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        enableXfwm = false;
        thunarPlugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
    };
    displayManager = {
       defaultSession = "xfce"; 
       startx.enable = false;
       lightdm = {
         enable = true;
         background = wallpaper;
         greeters.gtk = {
           enable = true;
           theme.name = "Dracula";
           iconTheme.name = "Papirus-Dark";
         };
       };
    };
  };
}
