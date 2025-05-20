{
  config,
  lib,
  ...
}:
{
  options.marchcraft.desktop.swaync.enable = lib.mkEnableOption "install swaync";
  config = lib.mkIf config.marchcraft.desktop.swaync.enable {
    services.swayosd =
      let
        catpuccinStyle = builtins.fetchurl "https://raw.githubusercontent.com/Zakar98k/hyprland-catppuccin-dotz/main/swaync/style.css";
      in
      {
        enable = true;
      };
  };
}
