{ config, pkgs, lib, options, ... }:

let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
  basicPackages = import ./packages/basic-packages.nix pkgs;
  desktopBasics = import ./packages/desktop-basics.nix pkgs;
  myApps = import ./packages/my-apps.nix pkgs unstable;
  developmentPackages = import ./packages/development-packages.nix pkgs unstable;
in 
{
  imports =
    [ <home-manager/nixos>
      ./home/simen.nix
      ./home/jamila.nix
    ];
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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
        efiSupport = true;
        device = "nodev";
      };
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
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
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };
    firewall.enable = true;
    nftables.enable = true;
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

    # Enable teamviewer
    teamviewer.enable = true;
    
    # Connect to zerotier network
    zerotierone = {
      enable = true;
      joinNetworks = [
        ""
      ];
    };

    # Enable blueman
    blueman.enable = true;   

    # Rule for full control of usb
    udev.extraRules = ''
      SUBSYSTEM=="usb", MODE="0666", GROUP="users"
    '';

    # PipeWire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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

  # Enable docker
  virtualisation = {
    docker.enable = true;
    kvmgt.enable = true;
    libvirtd.enable = true;
  };
  
  hardware = {
    pulseaudio.enable = false;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # rtkit for PipeWire
  security.rtkit.enable = true;

  programs = {
    tmux.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = basicPackages ++ desktopBasics ++ developmentPackages ++ myApps;

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ 
      "electron-25.9.0"
    ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}

