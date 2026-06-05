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
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0; # Open bootloader list by pressing any key
    };
    plymouth.enable = true;
    supportedFilesystems = [
      "ntfs"
    ];
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  powerManagement.enable = true;

  networking = {
    hostName = "schimen-laptop-nixos"; # Define your hostname.
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
      ];
    };
    firewall.enable = true;
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
    # Power management
    power-profiles-daemon.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandlePowerKey = "hibernate";
      HandlePowerKeyLongPress = "poweroff";
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Avahi settings for printing
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    # Rule for full control of usb
    udev.extraRules = ''
      SUBSYSTEM=="usb", MODE="0666", GROUP="users"
    '';

    # PipeWire
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    libinput.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "no";
    };
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';

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
    virt-manager.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = basicPackages ++ desktopBasics ++ developmentPackages ++ myApps;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
