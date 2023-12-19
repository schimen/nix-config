pkgs:

let 
  customFonts = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "Iosevka"
    ];
  };
in
{
  fonts.fonts = with pkgs; [
    material-design-icons
    tamsyn
    roboto
    noto-fonts
    font-awesome
    customFonts
  ];

  powerManagement.enable = true;
  environment.systemPackages = with pkgs.xfce // pkgs; [
    glib
    gtk2
    gtk3
    gtk4

    libnotify
    xdg-user-dirs
    lightlocker
    pavucontrol
    networkmanagerapplet
    wmname
    feh
    brightnessctl
    nomacs
    mupdf
    gnome.gnome-disk-utility
    gnome.file-roller
    gnome.gnome-tweaks
    system-config-printer
    lxqt.lxqt-policykit

    (callPackage ../packages/ideapad-cm {})
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
	  tappingButtonMap = "lrm";
	  tappingDragLock = true;
        };
      };
      
      gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    };
    tumbler.enable = true;
  };
 
  security.polkit.enable = true;

  programs.dconf.enable = true;

  # Shell integration for VTE terminals
  programs.bash.vteIntegration = true;
}
