{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.marchcraft.desktop.apps.kitty = {
    enable = lib.mkEnableOption "install the kitty config";
  };

  config =
    let
      tinted-theme = config.lib.stylix.colors {
        templateRepo = config.stylix.inputs.tinted-kitty;
        target = "default";
      };

      theme = pkgs.runCommandLocal "kitty-theme.conf" { } ''
        sed -e '0,/^# normal/I!d' ${tinted-theme} > $out
      '';
    in
    lib.mkIf config.marchcraft.desktop.apps.kitty.enable {
      home.packages = [
        pkgs.noto-fonts
        pkgs.noto-fonts-emoji
      ];

      stylix.targets.kitty.enable = true;

      programs.kitty = {
        # font = {
        #   inherit (config.stylix.fonts.monospace) package name;
        #   size = config.stylix.fonts.sizes.terminal;
        # };
        #
        enable = true;

        shellIntegration = {
          enableBashIntegration = true;
          enableFishIntegration = true;
        };

        keybindings = {
          "ctrl+plus" = "change_font_size all +1.0";
          "ctrl+minus" = "change_font_size all -1.0";
        };

        settings = {
          # background_opacity = 0.95;
          update_check_interval = 0;
          confirm_os_window_close = 0;
          mouse_hide_wait = 0;
          notify_on_cmd_finish = "invisible 30";
          disable_ligatures = "always";
          font_features = "MonocraftNerdFontComplete- -liga";
          touch_scroll_multiplier = 5;
          #include = toString theme;
        };
      };
    };
}
