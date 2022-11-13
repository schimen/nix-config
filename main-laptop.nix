{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = config.nixpkgs.config; };
  nurTarball = fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz";
  basicPackages = import ./packages/basic-packages.nix pkgs;
  myApps = import ./packages/my-apps.nix pkgs unstable;
  developmentPackages = import ./packages/development-packages.nix pkgs unstable;
  systec_can = (pkgs.callPackage ./packages/systec_can { kernel=pkgs.linuxPackages.kernel; });

  wallpaper = pkgs.fetchurl {
    url = "https://i.redd.it/ni1r1agwtrh71.png";
    sha256 = "00sg8mn6xdiqdsc1679xx0am3zf58fyj1c3l731imaypgmahkxj2";
  };
in 
{
  imports =
    [ "${home-manager}/nixos"
      ./home/simen.nix
      ./home/jamila.nix
    ];

  boot = {
    extraModulePackages = [ systec_can ];
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
  
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    #interfaces.enp0s20f0u1u3.useDHCP = true; # ethernet
    interfaces.wlp0s20f3.useDHCP = true; # wifi
    networkmanager = {
      enable = true;
      dhcp = "dhclient"; # because of eduroam
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
    # Samba for printing
    samba = {
      enable = true;
      package = pkgs.sambaFull;
    };

    # Enable mDNS
    avahi.enable = true;
    avahi.nssmdns = true;
    
    # Enable onedrive
    onedrive.enable = true;

    # Enable blueman
    blueman.enable = true;   

    # Enable full gvfs support
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome.gvfs;
    };

    # rule for full control of usb
    udev.extraRules = ''
      SUBSYSTEM=="usb", MODE="0666", GROUP="users"
    '';

    xserver.layout = "no";
    xserver.libinput.enable = true;
    xserver.desktopManager.xterm.enable = false;
    xserver.desktopManager.gnome.enable = true;
    xserver.displayManager = {
      defaultSession = "none+xmonad"; 
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
    xserver.xrandrHeads = [ { # set primary monitor to built-in monitor 
      output = "eDP-1";
      primary = true; 
    } ];
  };

  # Enable sound.
  sound.enable = true;

  # Enable docker
  virtualisation = {
    docker.enable = true;
    kvmgt.enable = true;
    virtualbox.host.enable = true;
  };
  
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  qt5 = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  programs = {
    tmux.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    (callPackage ./packages/ideapad-cm {}) # script for conservation mode
  ] ++ basicPackages ++ myApps ++ developmentPackages;

  nixpkgs.config = {
    permittedInsecurePackages = [ "electron-14.2.9" ];
    allowUnfree = true;
    packageOverrides = pkgs: { unstable = unstable; };
  };
}

