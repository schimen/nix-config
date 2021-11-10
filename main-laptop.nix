{ config, pkgs, lib, ... }:

let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  nurTarball = fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz";
  
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
    sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
  };
in 
{
  imports =
    [ ./home.nix
      ./xmonad
    ];

  boot = {
    plymouth = {
      enable = true;
    };
    supportedFilesystems = [
      "ntfs"
    ];
    loader = {
      timeout = 1;
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        device = "nodev";
      };
    };
  };
  
  networking = {
    hostName = "schimen-laptop-nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    #interfaces.enp0s20f0u1u3.useDHCP = true; # ethernet
    interfaces.wlp0s20f3.useDHCP = true; # wifi
    networkmanager = {
      enable = true;
      dhcp = "dhclient";
      packages = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };
  };
    
  # Set your time zone.
  time.timeZone = "Europe/Oslo";
  
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "no";
  };
  services = { # List services that you want to enable:

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable mDNS
    #avahi.enable = true;
    #avahi.nssmdns = true;
    
    # Enable onedrive
    onedrive.enable = true;

    # Enable blueman
    blueman.enable = true;   

    # Enable full gvfs support
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome3.gvfs;
    };
 
    xserver = {
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
    udev.extraRules = ''
      SUBSYSTEM=="usb", MODE="0666", GROUP="users"
    '';
  };

  # Enable sound.
  sound.enable = true;

  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" ];
  };

  qt5 = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  programs = {
    nm-applet.enable = true;
    neovim.enable = true;
    tmux.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Tools
    vim
    wget
    curl
    unzip
    nomacs
    mupdf
    vscodium
    gnome.gnome-disk-utility
    gnome.file-roller
    usbutils
    
    # System
    xfce.xfce4-whiskermenu-plugin
    lightlocker
    brightnessctl
    dmenu
    wineWowPackages.stable
    neofetch
    pulseeffects-legacy
    system-config-printer
    wmname
    (callPackage ./ideapad-cm {}) # script for conservation mode
    
    # Themes
    papirus-icon-theme
    dracula-theme
    # Programming languages
    (python39.withPackages(ps: with ps; [ 
      aiohttp
      beautifulsoup4
      ipython
      ipykernel
      matplotlib
      numpy
      sympy
      pandas
      requests
      tkinter
    ]))
  ];

  nixpkgs.config = {
    allowUnfree = true;
    # packageOverrides = pkgs: {
    #   unstable = import unstableTarball {
    #     config = config.nixpkgs.config;
    #   };
    # };
  };
}

