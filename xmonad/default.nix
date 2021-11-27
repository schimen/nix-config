{ config, pkgs, ... }:
let 
  myThunarPlugins = with pkgs.xfce; [ 
    thunar-archive-plugin
    thunar-volman
  ];
in
{
  powerManagement.enable = true;
  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs.xfce // pkgs; [
    glib
    gtk3.out

    hicolor-icon-theme
    papirus-icon-theme
    dracula-theme
    
    desktop-file-utils
    shared-mime-info
    polkit_gnome
    xdg-user-dirs

    exo
    garcon
    libxfce4ui
    xfconf

    (thunar.override { thunarPlugins = myThunarPlugins; })
    xfce4-notifyd
    xfce4-panel
    xfce4-whiskermenu-plugin
    xfce4-terminal
    xfce4-taskmanager
    xfce4-settings
    xfce4-screenshooter
    xfce4-pulseaudio-plugin
    xfce4-power-manager
    xfce4-notifyd
    networkmanagerapplet
    pavucontrol
  ];

  environment.pathsToLink = [
    "/share/xfce4"
    "/lib/xfce4"
    "/share/gtksourceview-3.0"
    "/share/gtksourceview-4.0"
  ];

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    #Configure keymap in X11
    layout = "no";

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };

    desktopManager.xterm.enable = false;

    updateDbusEnvironment = true;
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  };

  services = {
    udisks2.enable = true;
    accounts-daemon.enable = true;
    upower.enable = true;
    gnome.glib-networking.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
  };
 
  security.polkit.enable = true;
  
  # Enable default programs
  programs.dconf.enable = true;

  # Shell integration for VTE terminals
  programs.bash.vteIntegration = true;

  # Systemd services
  systemd.packages = with pkgs.xfce; [
    (thunar.override { thunarPlugins = myThunarPlugins; })
    xfce4-notifyd
  ];
}
