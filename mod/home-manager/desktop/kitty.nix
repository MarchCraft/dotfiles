{ config
, pkgs
, lib
, ...
}: {
  options.marchcraft.desktop.apps.kitty = {
    enable = lib.mkEnableOption "install the kitty config";
  };

  config = lib.mkIf config.marchcraft.desktop.apps.kitty.enable {
    home.packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-emoji
    ];

    stylix.targets.kitty.enable = true;

    programs.kitty = {
      enable = true;

      keybindings = {
        "ctrl+plus" = "change_font_size all +1.0";
        "ctrl+minus" = "change_font_size all -1.0";
      };
    };
  };
}
