{ config, pkgs, lib, ... }:

let
  basicPackages = import ./packages/basic-packages.nix pkgs;
  desktopBasics = import ./packages/desktop-basics.nix pkgs;
in 
{
  imports =
    [ <home-manager/nixos>
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

    # Avahi settings for printing
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    libinput.enable = true;
    displayManager.defaultSession = "gnome";
    xserver = {
      enable = true;
      xkb.layout = "no";
      desktopManager = {
        xterm.enable = false;
        gnome.enable = true;
      };
      displayManager = {
        startx.enable = false;
        gdm.enable = true;
      };
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.tmux.enable = true;

  environment.systemPackages = with pkgs; basicPackages ++ desktopBasics;

  nixpkgs.config.allowUnfree = true;
}

