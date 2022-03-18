let
  create-icon-path = theme-name: size: category:
    "/run/current-system/sw/share/icons/" + theme-name + "/" + size + "/" + category;
  icon-theme = "Papirus-Dark";
  icon-size  = "16x16";
  categories = [
    "actions"
    "animations"
    "apps"
    "categories"
    "devices"
    "emblems"
    "emotes"
    "filesystem"
    "intl"
    "legacy"
    "mimetypes"
    "places"
    "status"
    "stock"
  ];
  icon-path = builtins.concatStringsSep ":" (builtins.map (create-icon-path icon-theme icon-size) categories);
in
  builtins.toFile "dunstrc" (builtins.replaceStrings
    [ "ICON_PATH" ] [ icon-path ] (builtins.readFile ./dunstrc))
