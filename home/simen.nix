{ config, pkgs, ... }:
let
  commonUserPackages  = import ../packages/common-user-packages.nix pkgs;
  alacritty-settings = import ../alacritty/settings.nix pkgs.lib;
in
{
  imports = [
    (import ../xsession pkgs)
  ];

  users.users.simen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" "docker" ];
  };

  home-manager.users.simen = {
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
	  "clip"  = "xclip -selection clipboard";
        };
	bashrcExtra = ''
          eval "$(direnv hook bash)"
          PS1="\n\[\033[1;32m\]\[\e]0;\u@\h: \w\a\]\u:\w \[\033[1;34m\]\$\[\033[0m\] "
        '';
      };
      alacritty = {
        enable = true;
        settings = alacritty-settings;
      };
    };
    services.pulseeffects.enable = true;
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
