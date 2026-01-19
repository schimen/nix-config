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
      ./media-server.nix
    ];
  
  boot = {
    plymouth = {
      enable = true;
    };
    supportedFilesystems = [                                                                 
      "ntfs"                                                                                 
      "apfs"
    ];
    kernelModules = [ "i2c-dev" ];
    loader = {
      timeout = 5;
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        devices = [ "nodev" ];
        extraEntries = ''
          menuentry "macOS (Clover)" {
            insmod chain
            insmod part_gpt
            insmod search_fs_uuid
            search --fs-uuid --no-floppy --set=root 67E3-17ED
            chainloader /EFI/CLOVER/CLOVERX64.efi
          }
        '';
      };
    };
  };

  networking = {
    hostName = "schimen-desktop-nixos"; # Define your hostname.
    wireless.enable = false;  # no wireless on my desktop :(

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.         
    # Per-interface useDHCP will be mandatory in the future, so this generated config        
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.eno1.useDHCP = true; # ethernet
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
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

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable ssh
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };

    # Enable mDNS
    avahi.enable = true;
    avahi.nssmdns4 = true;
    avahi.publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
    
    # PipeWire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    pulseaudio.enable = false;

    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    xserver = {
      enable = true;
      xkb.layout = "no";
    };
    hardware.openrgb.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    kvmgt.enable = true;
    libvirtd.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    cpu.intel.updateMicrocode = true;
    i2c.enable = true;
    enableAllFirmware = true;
  };

  # rtkit for PipeWire
  security.rtkit.enable = true;

  programs = {
    tmux.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
  };

  environment.systemPackages = with pkgs; [ 
      apfs-fuse
      ltunify 
      openrgb
    ] ++ basicPackages ++ desktopBasics ++ myApps ++ developmentPackages;
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

