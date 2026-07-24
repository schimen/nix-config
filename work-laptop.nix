{ config, pkgs, lib, options, ... }:

let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
  basicPackages = import ./packages/basic-packages.nix pkgs;
  desktopBasics = import ./packages/desktop-basics.nix pkgs;
  myApps = import ./packages/my-apps.nix pkgs unstable;
  academicPackages = import ./packages/academic-packages.nix pkgs unstable;
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
      timeout = 0; # Open bootloader list by pressing any key
    };
    plymouth.enable = true;
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.systemd.enable = true;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
  
  powerManagement.enable = true;

  networking = {
    hostName = "simen-laptop-ntnu"; # Define your hostname.
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
    
    # Rule for full control of usb
    udev.extraRules = ''
      SUBSYSTEM=="usb", MODE="0666", GROUP="users"
    '';

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable mDNS
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

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

    # For executing non-standard shebangs
    envfs.enable = true;

    clamav = {
      daemon.enable = true;
      daemon.settings = {
        OnAccessPrevention = true;
        OnAccessIncludePath = "/home/simen/Downloads";
      };
      updater.enable = true;
      clamonacc.enable = true;
    };
  };

  systemd.services.dlm.wantedBy = [ "multi-user.target" ];
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "30m";
    SuspendState = "mem";
  };

  # Enable docker
  virtualisation = {
    docker.enable = true;
    kvmgt.enable = true;
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  
  # rtkit for PipeWire
  security.rtkit.enable = true;

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    open-sans
  ];

  programs = {
    tmux.enable = true;
    firefox.enable = true;
    virt-manager.enable = true;
    nix-ld.enable = true;
  };

  environment.systemPackages = basicPackages ++ desktopBasics ++ developmentPackages ++ myApps ++ academicPackages ++ [ pkgs.displaylink ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "googleearth-pro-7.3.7.1155"
    ];
  };
}
