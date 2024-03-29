let
  # dracula color theme
  dracula-theme = {
    colors = {
      primary = {
        background = "#282a36";
        foreground = "#f8f8f2";
        bright_foreground = "#ffffff";
      };
      cursor = {
        text   = "CellBackground";
        cursor = "CellForeground";
      };
      vi_mode_cursor = {
        text   = "CellBackground";
        cursor = "CellForeground";
      };
      search = {
        matches = {
          foreground = "#44475a";
          background = "#50fa7b";
        };
        focused_match = {
          foreground = "#44475a";
          background = "#ffb86c";
        };
      };
      footer_bar = {
        background = "#282a36";
        foreground = "#f8f8f2";
      };
      hints = {
        start = {
          foreground = "#282a36";
          background = "#f1fa8c";
        };
        end = {
          foreground = "#f1fa8c";
          background = "#282a36";
        };
      };
      line_indicator = {
        foreground = "None";
        background = "None";
      };
      selection = {
        text = "CellForeground";
        background = "#44475a";
      };
      normal = {
        black = "#21222c";
        red = "#ff5555";
        green = "#50fa7b";
        yellow = "#f1fa8c";
        blue = "#bd93f9";
        magenta = "#ff79c6";
        cyan = "#8be9fd";
        white = "#f8f8f2";
      };
      bright = {
        black = "#6272a4";
        red = "#ff6e6e";
        green = "#69ff94";
        yellow = "#ffffa5";
        blue = "#d6acff";
        magenta = "#ff92df";
        cyan = "#a4ffff";
        white = "#ffffff";
      };
    };
  };
  iosevka = {
    size = 8;
    normal = { # Normal (roman) font face
      family = "Iosevka Nerd Font";
      style = "Regular";
    };
    bold = { # Bold font face
      family = "Iosevka Nerd Font";
      style = "Bold";
    };
    italic = { # Italic font face
      family = "Iosevka Nerd Font";
      style = "Italic";
    };
    bold_italic = { # Bold italic font face
      family = "Iosevka Nerd Font";
      style = "Bold Italic";
    };
  };
in
  lib: lib.mergeAttrs {
    env.TERM = "xterm-256color";
    font = iosevka;  
  } dracula-theme
