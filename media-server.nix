{ config, pkgs, ... }:
{
  services = {
    # Add Samba for browseable drives over network
    samba = {
      package = pkgs.samba4Full;
      enable = true;
      securityType = "user";
      openFirewall = true;
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
        security = user 
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 192.168.0. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';
      shares = {
        Movies = {
          path = "/run/media/simen/SimenBackup/Filmer";
          browseable = "yes";
          "writeable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
        Series = {
          path = "/run/media/simen/SimenBackup/Serier";
          browseable = "yes";
          "writeable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
        Backup = {
          path = "/run/media/simen/SimenBackup/borg-backup";
          browseable = "yes";
          "writeable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
        Images = {
          path = "/run/media/simen/SimenBackup/Bilder";
          browseable = "yes";
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
  };

  # Add jellyfin packages
  environment.systemPackages = with pkgs; [
    jellyfin jellyfin-web jellyfin-ffmpeg
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
}

