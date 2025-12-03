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
    ];
  
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
  
  networking = {
    hostName = "simen-laptop-ntnu"; # Define your hostname.
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
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
    keyMap = "no";
  };

  services = { # List services that you want to enable:

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable mDNS
    avahi.enable = true;

    # PipeWire
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    onedrive.enable = true;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "no";
      videoDrivers = [ "displaylink" ];
    };
  };

  systemd.services.dlm.wantedBy = [ "multi-user.target" ];

  # Enable docker
  virtualisation = {
    docker.enable = true;
    kvmgt.enable = true;
    libvirtd.enable = true;
  };
  
  # rtkit for PipeWire
  security.rtkit.enable = true;

  programs = {
    tmux.enable = true;
    firefox.enable = true;
  };

  environment.systemPackages = basicPackages ++ desktopBasics ++ developmentPackages ++ myApps ++ [ pkgs.displaylink ];

  nixpkgs.config.allowUnfree = true;
}

