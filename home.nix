{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz";
  commonUserPackages = import ./packages/common-user-packages.nix pkgs;
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.simen = {
    home.packages = commonUserPackages; # User packages 
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
