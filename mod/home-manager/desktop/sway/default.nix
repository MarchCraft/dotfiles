{ config
, lib
, pkgs
, inputs
, ...
}: {
  imports = [
    ./wallpaper.nix
  ];

  options.marchcraft.desktop.sway = {
    enable = lib.mkEnableOption "install the sway config";
  };

  config = lib.mkIf config.marchcraft.desktop.sway.enable {
    home.packages = with pkgs; [
      grim
      slurp
      pamixer
      brightnessctl
      wlinhibit
      xdg-desktop-portal-gtk
      xdg-desktop-portal-xapp
      xdg-desktop-portal-gnome
      xdg-desktop-portal-wlr
      wl-clipboard
      autotiling
    ];

    home.pointerCursor = {
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 100;
      x11 = {
        enable = true;
        defaultCursor = config.home.pointerCursor.name;
      };
    };

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WAYLAND_DISPLAY = "wayland-1";
    };

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
      checkConfig = false;
      extraConfig = ''
        blur on
        smart_corner_radius on
        corner_radius 10
      '';
      config = {
        modifier = "Mod4";
        defaultWorkspace = "workspace number 1";
        terminal = "${pkgs.kitty}/bin/kitty";
        input = {
          "*" = {
            xkb_layout = "de";
            xkb_variant = "nodeadkeys";
          };
        };

        output = {
          eDP-1 = {
            scale = "1.7";
          };
        };

        startup = [
          { command = "waybar"; }
          { command = "swayidle"; }
          { command = "autotiling"; always = true; }
          { command = "wayvnc"; }
        ];

        window = {
          titlebar = false;
        };

        gaps = {
          outer = 2;
          inner = 3;
        };

        seat = {
          "*" = {
            hide_cursor = "when-typing enable";
          };
        };

        bars = [ ];

        keybindings =
          let
            modifier = config.wayland.windowManager.sway.config.modifier;
            swaylockConfig = builtins.toFile "swaylock.conf" ''
              screenshots
              clock
              indicator
              indicator-radius=100
              indicator-thickness=7
              effect-blur=7x5
              effect-vignette=0.5:0.5
              ring-color=bb00cc
              key-hl-color=880033
              line-color=00000000
              inside-color=00000088
              separator-color=00000000
            '';
          in
          lib.mkOptionDefault {
            "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty -e tmux";
            "${modifier}+c" = "kill";
            "${modifier}+w" = "exec ${pkgs.stable.firefox}/bin/firefox";
            "${modifier}+r" = "exec ${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons -dpi 120";
            "${modifier}+Shift+r+" = "exec rofi -show calc -modi calc -no-show-match -no-sort -no-persist-history -calc-command \"echo -n '{result}' | wl-copy\"";
            "${modifier}+p" = "exec ${pkgs.rofi-rbw-wayland}/bin/rofi-rbw";
            "${modifier}+m" = "exec ${pkgs.wlogout}/bin/wlogout";
            "${modifier}+l" = "exec ${pkgs.swaylock-effects}/bin/swaylock -C ${swaylockConfig}";
            "XF86AudioLowerVolume" = "exec pamixer -d 5";
            "XF86AudioRaiseVolume" = "exec pamixer -i 5";
            "XF86AudioMute" = "exec pamixer -t";
            "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
            "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
            "${modifier}+XF86MonBrightnessDown" = "exec brightnessctl -d kbd_backlight set 10%-";
            "${modifier}+XF86MonBrightnessUp" = "exec brightnessctl -d kbd_backlight set 10%+";
          };
      };
    };
  };
}
