{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.marchcraft.desktop.river = {
    enable = lib.mkEnableOption "install the river config";
    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Keyboard layout to use in river.";
    };
    scale = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Scale factor for HiDPI displays in river.";
    };
  };

  config = lib.mkIf config.marchcraft.desktop.river.enable {
    home.packages = with pkgs; [
      rivercarro
      wlr-randr
      xdg-desktop-portal-wlr
      wl-clipboard
    ];

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "river";
      WAYLAND_DISPLAY = "wayland-1";
    };

    services.hyprpaper.enable = true;

    wayland.windowManager.river = {
      enable = true;
      extraConfig = ''
        wlr-randr --output eDP-1 --scale ${toString config.marchcraft.desktop.river.scale}

        systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river

        systemctl --user stop xdg-desktop-portal
        systemctl --user start xdg-desktop-portal

        rivercarro \
          -main-ratio 0.5 \
          -no-smart-gaps \
          -per-tag \
          &
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
        in
        {
          default-layout = "rivercarro";
          map.normal = {
            "Super H" = "focus-view previous";
            "Super L" = "focus-view next";
            "Super+Shift H" = "swap previous";
            "Super+Shift L" = "swap next";

            "Super U" = "focus-output previous";
            "Super I" = "focus-output next";
            "Super+Shift U" = "send-to-output previous";
            "Super+Shift I" = "send-to-output next";

            "Super Return" = spawn "kitty -e tmux";
            "Super R" = spawn "killall rofi || ${lib.getExe pkgs.rofi} -show drun -show-icons";
            "Super C" = "close";
            "Super F" = "toggle-fullscreen";
            "Super W" = spawn "firefox";

            "Super+Shift O" = spawn "loginctl lock-session";
            "Super M" = spawn "${lib.getExe pkgs.wlogout}";

            "Super" = generateTagBindings "set-focused-tags";
            "Super+Shift" = generateTagBindings "set-view-tags";
            "Super+Alt" = generateTagBindings "toggle-focused-tags";
            "Super+Shift+Alt" = generateTagBindings "toggle-view-tags";

            #Volume control
            "None XF86AudioRaiseVolume" = spawn "pamixer -i 5";
            "None XF86AudioLowerVolume" = spawn "pamixer -d 5";
            "None XF86AudioMute" = spawn "pamixer -t";

            #Brightness control
            "None XF86MonBrightnessUp" = spawn "brightnessctl set +5%";
            "None XF86MonBrightnessDown" = spawn "brightnessctl set 5%-";

            #Media control
            "None XF86AudioPlay" = spawn "playerctl play-pause";
            "None XF86AudioNext" = spawn "playerctl next";
            "None XF86AudioPrev" = spawn "playerctl previous";
          };
          keyboard-layout = config.marchcraft.desktop.river.keyboardLayout;
        };
    };
  };
}
