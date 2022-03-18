{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = config.nixpkgs.config; };
  nurTarball = fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz";
  basicPackages = import ./packages/basic-packages.nix pkgs;

  wallpaper = pkgs.fetchurl {
    url = "https://i.redd.it/ni1r1agwtrh71.png";
    sha256 = "00sg8mn6xdiqdsc1679xx0am3zf58fyj1c3l731imaypgmahkxj2";
  };
in 
{
  imports =
    [ "${home-manager}/nixos"
      ./home/simen.nix
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
    hostName = "schimen-old-nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s25.useDHCP = true; # ethernet
    interfaces.wlp4s0.useDHCP  = true; # wifi
    networkmanager = {
      enable = true;
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
    avahi.enable = true;
    avahi.nssmdns = true;

    # Enable full gvfs support
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome.gvfs;
    };
    xserver.desktopManager.xterm.enable = false;
    xserver.layout = "no";
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
  };

  # Enable sound.
  sound.enable = true;

  hardware.pulseaudio.enable = true;
 
  qt5 = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  programs.tmux.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    spotify
  ] ++ basicPackages;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: { unstable = unstable; };
  };
}

