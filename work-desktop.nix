{ config, pkgs, lib, options, ... }:

let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
  basicPackages = import ./packages/basic-packages.nix pkgs;
  desktopBasics = import ./packages/desktop-basics.nix pkgs;
  developmentPackages = import ./packages/development-packages.nix pkgs unstable;
in
{
  imports =
    [ <home-manager/nixos>
      ./home/simen.nix
    ];

  users.users.simen.openssh.authorizedKeys.keys = [
    # content of authorized_keys file
    # note: ssh-copy-id will add user@your-machine after the public key
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "ntfs" ];
  };

  networking = {
    hostName = "simen-desktop-ntnu"; # Define your hostname.
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "no";
  };

  services = {
    # Enable mDNS
    avahi.enable = true;

    # Access over RDP
    xserver.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
    xserver.desktopManager.xfce.enable = true;
    xserver.displayManager.lightdm.enable = true;
    xrdp = {
      enable = true;
      defaultWindowManager = "xfce4-session";
      openFirewall = true;
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

    # Enable ssh access for user simen
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "simen" ];
        X11Forwarding = true;
      }; 
    };

    fail2ban.enable = true;
  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  # Enable docker
  virtualisation = {
    docker.enable = true;
    kvmgt.enable = true;
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  programs = {
    tmux.enable = true;
    firefox.enable = true;
    virt-manager.enable = true;
    nix-ld.enable = true;
  };

  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };

  environment.systemPackages = basicPackages ++ desktopBasics ++ developmentPackages;
  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };
}
