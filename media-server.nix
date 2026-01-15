{ config, pkgs, ... }:
{
  services = {
    # Add Samba for browseable drives over network
    samba = {
      package = pkgs.samba4Full;
      enable = true;
      securityType = "user";
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "Movies" = {
          "path" = "/run/media/simen/SimenBackup/Filmer";
          "browseable" = "yes";
          "writeable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
        "Series" = {
          "path" = "/run/media/simen/SimenBackup/Serier";
          "browseable" = "yes";
          "writeable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
        "Backup" = {
          "path" = "/run/media/simen/SimenBackup/borg-backup";
          "browseable" = "yes";
          "writeable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
        "Images" = {
          "path" = "/run/media/simen/SimenBackup/Bilder";
          "browseable" = "yes";
          "writeable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
        "Music" = {
          "path" = "/run/media/simen/SimenBackup/Musikk";
          "browseable" = "yes";
          "writeable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
      };
    };
    samba-wsdd = {
      # make shares visible for Windows clients
      enable = true;
      openFirewall = true;
    };

    # Enable jellyfin media server
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "simen";
    };

    # Remote desktop to access the server
    xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
      openFirewall = true;
    };
    # Use Gnome for remote desktop
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
    };
    gnome.gnome-remote-desktop.enable = true;

    # Disable autologin to avoid session conflicts
    displayManager.autoLogin.enable = false;
    getty.autologinUser = null;


    # ZeroTier to access server outside of local network
    zerotierone = {
      enable = true;
      joinNetworks = [
        ""
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    # Jellyfin packages
    jellyfin jellyfin-web jellyfin-ffmpeg
    # Remote desktop package
    gnome-remote-desktop
    # ZeroTier for access outside of local network
    zerotierone
  ];

  # Enable VA-API (see https://nixos.wiki/wiki/Jellyfin)
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime
    ];
  };

  users.users.rdp-user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}

