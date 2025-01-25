{ config, pkgs, ... }:
{
  users.users.simen = {
    isNormalUser = true;
    extraGroups = [
      "wheel" "networkmanager" "dialout" "docker" "kvm" "libvirtd"
    ];
  };

  home-manager.users.simen = {
    home.stateVersion = "22.11";
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
          "clip" = "xclip -selection clipboard";
          "ls"   = "ls --color=auto";
          "grep" = "grep --color=auto";
        };
        bashrcExtra = ''
          eval "$(direnv hook bash)"
          PS1="\n\[\033[1;32m\]\u@\h\[\033[00m\]:\[\033[1;34m\]\w\[\033[00m\]\$ "
        '';
      };
    };
  };
}
