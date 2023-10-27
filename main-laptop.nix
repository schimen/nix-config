{ config, pkgs, lib, options, ... }:

let
  basicPackages = import ./packages/basic-packages.nix pkgs;
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
  myApps = import ./packages/my-apps.nix pkgs unstable;
  developmentPackages = import ./packages/development-packages.nix pkgs unstable;
  wallpaper = pkgs.fetchurl {
    url = "https://i.redd.it/ni1r1agwtrh71.png";
    sha256 = "00sg8mn6xdiqdsc1679xx0am3zf58fyj1c3l731imaypgmahkxj2";
  };
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
      timeout = 1;
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
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
      #dhcp = "dhcpcd"; # because of eduroam
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };
    # Samba discovery of machines and shares may need the firewall to be tuned (https://nixos.wiki/wiki/Samba)
    firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };

  systemd.services = { # Temporary solution before nixpkgs issue #180175 is resolved
    NetworkManager-wait-online.enable = lib.mkForce false;
    systemd-networkd-wait-online.enable = lib.mkForce false;
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
      nssmdns = true;
      openFirewall = true;
    };

    # Enable teamviewer
    teamviewer.enable = true;
    
    # Enable onedrive
    onedrive.enable = true;

    # Enable blueman
    blueman.enable = true;   

    # Enable full gvfs support
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome.gvfs;
    };

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

    xserver = {
      layout = "no";
      libinput.enable = true;
      desktopManager.xterm.enable = false;
      desktopManager.gnome.enable = true;
      displayManager = {
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
      xrandrHeads = [ { # set primary monitor to built-in monitor 
        output = "eDP-1";
        primary = true; 
      } ];
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
    bluetooth.enable = true;
  };

  # rtkit for PipeWire
  security.rtkit.enable = true;

  qt = {
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
    permittedInsecurePackages = [ 
      "electron-24.8.6"
      "teams-1.5.00.23861"
      "zotero-6.0.26"
    ];
    allowUnfree = true;
    segger-jlink.acceptLicense = true;
    packageOverrides = pkgs: { unstable = unstable; };
    allowUnsupportedSystem = true;
  };
  nixpkgs.overlays = [
    (import ./overlays/realvnc.nix)
  ];
}

