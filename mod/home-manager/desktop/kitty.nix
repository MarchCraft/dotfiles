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
      (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];

    stylix.targets.kitty.enable = false;

    programs.kitty = {
      enable = true;

      font.size = 9;
      font.name = "DejaVu Sans";

      keybindings = {
        "ctrl+plus" = "change_font_size all +1.0";
        "ctrl+minus" = "change_font_size all -1.0";
      };

      settings = {
        confirm_os_window_close = 0;
        foreground = "#CDD6F4";
        background = "#1E1E2E";
        selection_foreground = "#1E1E2E";
        selection_background = "#F5E0DC";
        mark1_foreground = "#1E1E2E";
        mark1_background = "#B4BEFE";
        mark2_foreground = "#1E1E2E";
        mark2_background = "#CBA6F7";
        mark3_foreground = "#1E1E2E";
        mark3_background = "#74C7EC";
        cursor = "#F5E0DC";
        cursor_text_color = "#1E1E2E";
        url_color = "#F5E0DC";
      };
    };
  };
}
