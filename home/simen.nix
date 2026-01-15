{ config, pkgs, ... }:
{
  users.users.simen = {
    isNormalUser = true;
    description = "Simen Løcka Eine";
    extraGroups = [
      "wheel" "networkmanager" "dialout" "docker" "kvm" "libvirtd"
    ];
    packages = [ pkgs.wl-clipboard ];
  };

  home-manager.users.simen = {
    home.stateVersion = "25.11";
    home.keyboard.layout = "no";
    programs = {
      home-manager.enable = true;
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
      tmux = {
        enable = true;
        keyMode = "vi";
        clock24 = true;
        mouse = true;
        extraConfig = ''
          set -s set-clipboard off
          set -s copy-command 'wl-copy'
        '';
      };
    };
  };
}
