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

    libnotify
    lightlocker
    pavucontrol
    pulseeffects-legacy
    networkmanagerapplet    

    papirus-icon-theme
    dracula-theme

    xdg-user-dirs
    xfconf
    xfce4-terminal
    xfce4-taskmanager
    xfce4-settings
    xfce4-screenshooter
    xfce4-power-manager
    (thunar.override { thunarPlugins = myThunarPlugins; })
    rofi

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
    gvfs.enable = true;

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
        config = ./xmonad/xmonad.hs;
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

  home-manager.users.simen = {
    services = {
      polybar = {
        enable = true;
        package = myPolybar;
        config = ./polybar/config.ini;
        script = ''
        '';
      };
      dunst = {
        enable = true;
        iconTheme = with pkgs; {
          name = "Papirus-Dark";
          package = papirus-icon-theme;
          #size = "16x16";
        };
        settings.global = {
          #shrink = "yes";
          transparency = 10;
          #padding = 16;
          #horizontal_padding = 16;
          #font = "JetBrainsMono Nerd Font 10";
          #line_height = 4;
          #format = ''<b>%s</b>\n%b'';
        };
      };
      screen-locker = {
        enable = true;
        inactiveInterval = 15;
        lockCmd = "${pkgs.lightlocker}/bin/light-locker-command --lock";
      };
      picom = {
        enable = true;
        blur = true;
	blurExclude = [ "'class_g' = 'xfce4-screenshooter'" ];
        activeOpacity = "1.0";
        inactiveOpacity = "0.8";
        backend = "glx";
        opacityRule = [ "100:name *= 'light-locker'" ];
        shadow = true;
        shadowOpacity = "0.5";
      };
      pulseeffects = {
        enable = true;
        package = pkgs.pulseeffects-legacy;
      };
    };
    xsession = {    
      enable = true;
      initExtra = with pkgs; ''
        ${picom}/bin/picom &
        ${myPolybar}/bin/polybar top  &
        ${dunst}/bin/dunst &
        ${blueman}/bin/blueman-applet &
        ${networkmanagerapplet}/bin/nm-applet --sm-disable --indicator &
        ${xfce.xfce4-power-manager}/bin/xfce4-power-manager --daemon &
        ${lightlocker}/bin/light-locker &
      '';
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ./xmonad/xmonad.hs;
      };
    };  
  };
}
