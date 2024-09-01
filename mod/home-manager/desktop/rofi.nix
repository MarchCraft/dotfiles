{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.rofi =
    {
      enable = lib.mkEnableOption "install rofi";
      rbw-config-file = lib.mkOption {
        description = "path to config file of rbw";
        type = lib.types.str;
        default = true;
      };
    };
  config =
    let
      opts = config.marchcraft.rofi;
    in
    lib.mkIf config.marchcraft.rofi.enable {

      home.packages = with pkgs; [
        rbw
        rofi-rbw-wayland
        rofi-power-menu
        rofimoji
        rofi-bluetooth
      ];

      sops.secrets.rbw = {
        format = "binary";
        sopsFile = ../../../nixos/secrets/rbw;
        # path = "%%r/test.txt";
      };

      programs.rofi =
        {
          enable = true;
          package = pkgs.rofi-wayland-unwrapped;
          theme =
            let
              inherit (config.lib.formats.rasi) mkLiteral;
            in
            {
              "*" = {
                font = "Roboto 12";

                background-color = mkLiteral "transparent";
                text-color = mkLiteral "@fg0";

                margin = mkLiteral "0px";
                padding = mkLiteral "0px";
                spacing = mkLiteral "0px";
                bg0 = mkLiteral "#2E3440F2";
                bg1 = mkLiteral "#3B4252";
                bg2 = mkLiteral "#4C566A80";
                bg3 = mkLiteral "#88C0D0F2";
                fg0 = mkLiteral "#D8DEE9";
                fg1 = mkLiteral "#ECEFF4";
                fg2 = mkLiteral "#D8DEE9";
                fg3 = mkLiteral "#4C566A";
              };
              "
        window " =
                {
                  location = mkLiteral "
        center ";
                  width = 480;
                  border-radius = mkLiteral " 24
        px ";

                  background-color = mkLiteral "@bg0";
                };

              "mainbox" =
                {
                  padding = mkLiteral "12px";
                };

              "inputbar" =
                {
                  background-color = mkLiteral "@bg1";
                  border-color = mkLiteral "@bg3";

                  border = mkLiteral "2px";
                  border-radius = mkLiteral "16px";

                  padding = mkLiteral "8px 16px";
                  spacing = mkLiteral "8px";
                  children = map mkLiteral [ "prompt" "entry" ];
                };

              "prompt" =
                {
                  text-color = "mkLiteral @fg2";
                };

              "entry" = {
                placeholder = "Search";
                placeholder-color = mkLiteral "@fg3";
              };

              "message" =
                {
                  margin = mkLiteral "12px 0 0";
                  border-radius = mkLiteral "16px";
                  border-color = mkLiteral "@bg2";
                  background-color = mkLiteral "@bg2";
                };

              "textbox" =
                {
                  padding = mkLiteral "8px 24px";
                };

              "listview" = {
                background-color = mkLiteral "transparent";

                margin = mkLiteral "12px 0 0";
                lines = 8;
                columns = 1;

                fixed-height = mkLiteral "false";
              };

              "element" =
                {
                  padding = mkLiteral "8px 16px";
                  spacing = mkLiteral "8px";
                  border-radius = mkLiteral "16px";
                };

              "element selected" =
                {
                  text-color = mkLiteral "@bg1";
                };

              "element normal active" = {
                text-color = mkLiteral "@bg3";
              };

              "element alternate active" = {
                text-color = mkLiteral "@bg3";
              };

              "element selected normal, element selected active" = {
                background-color = mkLiteral "@bg3";
              };


              "element-icon" =
                {
                  size = mkLiteral "1em";
                  vertical-align = mkLiteral "0.5";
                };

              "element-text" =
                {
                  text-color = mkLiteral "inherit";
                };

            };
        };
    };
}



