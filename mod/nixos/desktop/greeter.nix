{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.greeter.enable = lib.mkEnableOption "enable the greeter";

  config = lib.mkIf config.marchcraft.greeter.enable {
    environment.systemPackages = with pkgs; [
      greetd.regreet
    ];

    programs.regreet = {
      enable = true;
      settings = builtins.fromTOML ''
        [background]
        path = "/etc/greetd/background.jpg"
        fit = "Fill"

        [env]

        [GTK]
        cursor_theme_name = "Dracula"
        font_name = "Cantarell 16"
        icon_theme_name = "Dracula"
        theme_name = "Dracula"
      '';
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session =
          let
            hyprlandConfig = builtins.toFile "hyprland.regreet.conf" ''
              exec-once = regreet; hyprctl dispatch exit;
              windowrulev2=fullscreen, title:^regreet$
              animations {
                  enabled = no
              }
              misc {
                  disable_hyprland_logo = yes
                  disable_splash_rendering = yes
              }
              input {
                  kb_layout = de
              }
            '';
          in
          {
            command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprlandConfig}";
          };
      };
    };
  };
}
