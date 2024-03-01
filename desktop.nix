{ config, pkgs, lib, options, ... }:

let
  basicPackages = import ./packages/basic-packages.nix pkgs;
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
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
    plymouth = {
      enable = true;
    };
    supportedFilesystems = [                                                                 
      "ntfs"                                                                                 
    ];
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
    openssh.enable = true;

    # Enable mDNS
    avahi.enable = true;
    avahi.nssmdns = true;
    avahi.publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
    
    # Enable onedrive
    onedrive.enable = true;

    # Enable teamviewer
    teamviewer.enable = true;

    # PipeWire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    xserver = {
      enable = true;
      layout = "no";
      desktopManager = {
        xterm.enable = false;
        gnome.enable = true;
      };
      displayManager = {
        startx.enable = false;
        gdm.enable = true;
        defaultSession = "gnome";
      };
    };
  };

  virtualisation = {
    docker.enable = true;
    kvmgt.enable = true;
    libvirtd.enable = true;
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
  };

  # rtkit for PipeWire
  security.rtkit.enable = true;

  programs = {
    tmux.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [ 
      ltunify 
    ] ++ basicPackages ++ myApps ++ developmentPackages;
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
}

