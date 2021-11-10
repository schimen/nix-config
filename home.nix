{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.simen = {
    # User packages 
    home.packages = with pkgs; [ 
      # Tools
      transmission-gtk
      qalculate-gtk
      direnv
      cutecom
      gnuradio
      texlive.combined.scheme-full
      gummi
      arduino

      # Apps
      firefox
      vlc
      discord
      teams
      slack
      obsidian
      libreoffice
      gimp
      thunderbird
      zoom-us
      spotify
      kicad
      freecad
      minecraft
      cura
      drawio
      musescore
      (callPackage ./geogebra {})   # geogebra 6
      (callPackage ./nrfconnect {}) # nRF Connect
      (callPackage ./notion {})     # Notion
    ];
    programs= {
      home-manager.enable = true;
      git = {
        enable = true;
        userName = "schimen";
        userEmail = "einesimen@gmail.com";
      };
      bash = {
        enable = true;
	shellAliases = {
	  "nconf" = "sudo nvim /etc/nixos/configuration.nix";
	  "nhome" = "sudo nvim /etc/nixos/home.nix";
        };
	bashrcExtra = ''
	  eval "$(direnv hook bash)"
	'';
      };
    };
  };
}
