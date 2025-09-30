{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.marchcraft.desktop.river = {
    enable = lib.mkEnableOption "install the river config";
  };

  config = lib.mkIf config.marchcraft.desktop.river.enable {
    marchcraft.desktop.swayidle.enable = true;

    home.packages = [
      pkgs.rivercarro
    ];

    services.hyprpaper.enable = true;

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "river";
      WAYLAND_DISPLAY = "wayland-1";
    };

    wayland.windowManager.river = {
      enable = true;

      extraConfig =
        let
          outputs = config.marchcraft.desktop.wmconfig.outputs;
          wlrRandr = lib.concatMapStrings (output: ''
            ${lib.getExe pkgs.wlr-randr} --output ${output.name} ${
              if output.scale != null then "--scale " + toString output.scale else ""
            } 
          '') outputs;
        in
        ''
          ${lib.traceValSeq wlrRandr}
          rivercarro \
          -main-ratio 0.6 \
          -no-smart-gaps \
          -per-tag &
        '';

      settings =
        let
          tagNames = map toString ((lib.range 1 9) ++ [ 0 ]);
          tagBits = [
            1
            2
            4
            8
            16
            32
            64
            128
            256
            512
            1024
          ];
          tags = lib.zipListsWith (name: mask: { inherit name mask; }) tagNames tagBits;

          spawn = cmd: "spawn \"${cmd}\"";

          superKey = config.marchcraft.desktop.wmconfig.superKey;

          generateTagBindings =
            option:
            lib.listToAttrs (
              lib.map (t: {
                inherit (t) name;
                value = {
                  "${option}" = t.mask;
                };
              }) tags
            );

          rule =
            app-id: title: action:
            lib.concatStringsSep " " [
              (lib.optionalString (app-id != null) "-app-id '${app-id}'")
              (lib.optionalString (title != null) "-title '${title}'")
              action
            ];

          generateGameRules =
            classes:
            lib.concatLists (
              map (class: [
                (rule class null "tags ${toString (builtins.elemAt tagBits 3)}")
                (rule class null "fullscreen")
                (rule class null "tearing")
              ]) classes
            );
        in
        {
          default-layout = "rivercarro";
          keyboard-layout = config.marchcraft.desktop.wmconfig.keyboardLayout;

          map.normal = {
            "${superKey} Return" = spawn "kitty -e tmux a";
            "${superKey} R" = spawn "${lib.getExe pkgs.rofi} -show drun -show-icons";
            "${superKey} W" = spawn "${lib.getExe pkgs.firefox}";
            "${superKey} C" = spawn "riverctl close";

            "${superKey}" = generateTagBindings "set-focused-tags";
            "${superKey}+Shift" = generateTagBindings "set-view-tags";
            "${superKey}+Alt" = generateTagBindings "toggle-focused-tags";
            "${superKey}+Shift+Alt" = generateTagBindings "toggle-view-tags";

            "${superKey} F" = spawn "riverctl toggle-fullscreen";

            # enter mode
            "${superKey} Escape" = "enter-mode power";
            "${superKey} D" = "enter-mode display";

          };

          declare-mode = [
            "power"
            "display"
          ];

          map.power = {
            "None Escape" = "enter-mode normal";
            "None E" = spawn "riverctl exit";
            "None L" = spawn "loginctl lock-session";
          };

          map.display = {
            "None Escape" = "enter-mode normal";
            "None M" = spawn "${lib.getExe pkgs.wl-mirror} eDP-1";
          };

          rule-add = [
            (rule "firefox" null "ssd")
            (rule "firefox" null "tags ${toString (builtins.elemAt tagBits 1)}")
            (rule "chromium-browser" null "ssd")
            (rule "chromium-browser" null "tags ${toString (builtins.elemAt tagBits 7)}")

            (rule "thunderbird" null "tags ${toString (builtins.elemAt tagBits 2)}")
            (rule "filezilla" null "tags ${toString (builtins.elemAt tagBits 2)}")
            (rule "libreoffice-*" null "tags ${toString (builtins.elemAt tagBits 2)}")
            (rule "soffice" null "tags ${toString (builtins.elemAt tagBits 2)}")

            (rule "org.prismlauncher.PrismLauncher" null "tags ${toString (builtins.elemAt tagBits 4)}")
            (rule "steam" null "tags ${toString (builtins.elemAt tagBits 4)}")
            (rule null "Steam" "tags ${toString (builtins.elemAt tagBits 4)}")

            (rule "discord" null "tags ${toString (builtins.elemAt tagBits 8)}")
            (rule "WebCord" null "tags ${toString (builtins.elemAt tagBits 8)}")
            (rule "vesktop" null "tags ${toString (builtins.elemAt tagBits 8)}")
            (rule "Element" null "tags ${toString (builtins.elemAt tagBits 8)}")
          ]
          ++ (generateGameRules [
            "steam_app_*"
            "Stardew Valley"
            "Minecraft*"
            "com.mojang.minecraft"
            "hl_linux"
            "org.libretro.RetroArch"
            "GT: New Horizons*"
          ]);
        };
    };
  };
}
