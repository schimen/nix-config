{ config, pkgs, ... }:
let
  commonUserPackages  = import ../packages/common-user-packages.nix pkgs;
in
{
  imports = [
    (import ../xsession pkgs)
  ];

  users.users.simen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" ];
  };

  home-manager.users.simen = {
    home.packages = commonUserPackages; # User packages 
    home.keyboard.layout = "no";
    programs = {
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
    gtk = {
      enable = true;
      iconTheme = with pkgs; {
        package = papirus-icon-theme;
	name = "Papirus-Dark";
      };
      theme = with pkgs; {
        package = dracula-theme;
	name = "Dracula";
      };
    }; 
  };
}
