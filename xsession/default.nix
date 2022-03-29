pkgs:

let 
  myPolybar = pkgs.polybar.override {
      alsaSupport  = true;
      pulseSupport = true;
  };
  myThunarPlugins = with pkgs.xfce; [ 
    thunar-archive-plugin
    thunar-volman
  ];
  customFonts = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "Iosevka"
    ];
  };
  wallpaper = pkgs.fetchurl {
    url = "https://i.redd.it/ni1r1agwtrh71.png";
    sha256 = "00sg8mn6xdiqdsc1679xx0am3zf58fyj1c3l731imaypgmahkxj2";
  };
  dunst-config = import ./dunst/config-file.nix;
  polybar-config = import ./polybar/config-file.nix;
  xmonad-config = pkgs.writeTextFile { 
     name = "xmonad.hs"; 
     text = (builtins.replaceStrings
       [ "POLYBAR-CONFIG"    "DUNST-CONFIG"   ] 
       [ "${polybar-config}" "${dunst-config}"]
       (builtins.readFile ./xmonad/xmonad.hs));
    };
in
{
  fonts.fonts = with pkgs; [
    material-design-icons
    tamsyn
    roboto
    noto-fonts
    font-awesome-ttf
    customFonts
  ];

  powerManagement.enable = true;
  hardware.pulseaudio.enable = true;
  environment.systemPackages = with pkgs.xfce // pkgs; [
    glib
    gtk2
    gtk3
    gtk4
    dracula-theme
    papirus-icon-theme

    libnotify
    xdg-user-dirs
    lightlocker
    pavucontrol
    pulseeffects-legacy
    networkmanagerapplet
    dmenu
    (rofi.override { plugins = [ rofi-calc ]; })
    wmname
    feh
    brightnessctl
    nomacs
    mupdf
    gnome.gnome-disk-utility
    gnome.file-roller
    system-config-printer
    lxqt.lxqt-policykit

    # xfce
    (thunar.override { thunarPlugins = myThunarPlugins; })
    xfce4-power-manager
    xfce4-screenshooter
    xfce4-settings
    xfce4-taskmanager
    xfconf

    # polybar stuff
    myPolybar
    picom
    dunst
    playerctl
    (callPackage ../packages/ideapad-cm {})
    (callPackage ./polybar/polybar-scripts.nix {})
  ];

  environment.pathsToLink = [
    "/share/xfce4"
    "/lib/xfce4"
    "/share/gtksourceview-3.0"
    "/share/gtksourceview-4.0"
  ];

  services = {
    udisks2.enable = true;
    accounts-daemon.enable = true;
    upower.enable = true;
    gnome.glib-networking.enable = true;
    gnome.gnome-keyring.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      updateDbusEnvironment = true;
      
      #Configure keymap in X11
      layout = "no";
      
      # Enable touchpad support (enabled default in most desktopManager).
      libinput = {
        enable = true;
	touchpad = {
	  tapping = true;
	  naturalScrolling = false;
	  scrollMethod = "twofinger";
	  horizontalScrolling = true;
        };
      };
      
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = xmonad-config;
      };
      gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    };
    tumbler.enable = true;
  };
 
  security.polkit.enable = true;

  programs.dconf.enable = true;

  # Shell integration for VTE terminals
  programs.bash.vteIntegration = true;

  # Systemd services
  systemd.packages = with pkgs.xfce; [
    (thunar.override { thunarPlugins = myThunarPlugins; })
  ];
}
