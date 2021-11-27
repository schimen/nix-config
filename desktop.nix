{ config, pkgs, lib, ... }:

let
  unstableTarball = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  unstable = import unstableTarball { config = config.nixpkgs.config; };
  commonSystemPackages = import ./packages/common-system-packages.nix pkgs;
  developmentPackages = import ./packages/development-packages.nix pkgs unstable;

  wallpaper = pkgs.fetchurl {
    url = "https://i.redd.it/ni1r1agwtrh71.png";
    sha256 = "00sg8mn6xdiqdsc1679xx0am3zf58fyj1c3l731imaypgmahkxj2";
  };
in
{
  imports =
    [ ./home.nix
      ./xmonad
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
        useOSProber = true;
        efiSupport = true;
        devices = [ "nodev" ];
        # extraEntries = ''
        #   menuentry "macOS (Clover)" {
        #     insmod chain
        #     insmod part_gpt
        #     insmod search_fs_uuid
        #     search --fs-uuid --no-floppy --set=root 67E3-17ED
        #     chainloader /EFI/CLOVER/CLOVERX64.efi
        #   }
        # '';
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
    #avahi.enable = true;
    #avahi.nssmdns = true;
    
    # Enable onedrive
    onedrive.enable = true;

    # Enable blueman
    blueman.enable = true;   

    # Enable full gvfs support
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome3.gvfs;
    };

    xserver.desktopManager.gnome.enable = true;
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

  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  qt5 = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  programs = {
    nm-applet.enable = true;
    tmux.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = commonSystemPackages ++ developmentPackages;
  
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: { unstable = unstable; }; 
  };
}

