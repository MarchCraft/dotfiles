{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.desktop.wayfire = {
    enable = lib.mkEnableOption "install the wayfire config";
  };

  config = lib.mkIf config.marchcraft.desktop.wayfire.enable
    {
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
        autotiling-rs
        grim
        slurp
        wlogout
        swww
      ];

      stylix = {
        fonts = {
          monospace = {
            package = pkgs.monocraft;
            name = "Monocraft Nerd Font Complete";
          };

          sansSerif = {
            package = pkgs.noto-fonts;
            name = "Noto Sans";
          };

          serif = {
            package = pkgs.noto-fonts;
            name = "Noto Serif";
          };
        };

        cursor = {
          package = pkgs.rose-pine-cursor;
          name = "BreezeX-RosePine-Linux";
        };

        opacity.terminal = 0.94;
      };

      wayland.windowManager.wayfire = {
        enable = true;
        plugins = [
          pkgs.wayfirePlugins.wcm
          pkgs.wayfirePlugins.windecor
        ];
        settings = {
          command =
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
            {
              binding_0 = "<super> KEY_ENTER";
              command_0 = "kitty -e tmux attach || tmux";
              binding_1 = "<super> KEY_W";
              command_1 = "firefox";
              binding_2 = "<super> KEY_R";
              command_2 = "rofi -show drun -show-icons";
              binding_3 = "<super> <shift> KEY_L";
              command_3 = "swaylock -C ${swaylockConfig}";
              binding_4 = "<super> KEY_M";
              command_4 = "wlogout";

              binding_volume_mute = "KEY_MUTE";
              command_volume_mute = "pamixer -t";
              repeatable_binding_volume_down = "KEY_VOLUMEDOWN";
              command_volume_down = "pamixer -d 5";
              repeatable_binding_volume_up = "KEY_VOLUMEUP";
              command_volume_up = "pamixer -i 5";

              binding_brightness_down = "KEY_BRIGHTNESSDOWN";
              command_brightness_down = "brightnessctl set 5%-";
              binding_brightness_up = "KEY_BRIGHTNESSUP";
              command_brightness_up = "brightnessctl set 5%+";

              bindung_keyboard_brightness_down = "<super> KEY_BRIGHTNESSDOWN";
              command_keyboard_brightness_down = "brightnessctl -d kbd_backlight set 5%-";
              bindung_keyboard_brightness_up = "<super> KEY_BRIGHTNESSUP";
              command_keyboard_brightness_up = "brightnessctl -d kbd_backlight set 5%+";
            };
          autostart =
            let
              background = pkgs.fetchurl {
                url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nixos-wallpaper-catppuccin-mocha.png?raw=true";
                hash = "sha256-fmKFYw2gYAYFjOv4lr8IkXPtZfE1+88yKQ4vjEcax1s=";
              };
            in
            {
              autostart_0 = "waybar";
              autostart_1 = "swayidle";
              autostart_2 = "swaync";
              autostart_3 = "swww init && swww img --transition-type none ${background}";
              autostart_4 = "${pkgs.mpris-scrobbler}/bin/mpris-scrobbler";
            };
          output = {
            depth = 8;
            mode = "auto";
            position = "auto";
            scale = 2;
            transform = "normal";
            vrr = true;
          };
          core = {
            close_top_view = "<super> KEY_C";
            plugins = "autostart command cube expo fisheye foreign-toplevel switcher vswitch wobbly wrot simple-tile wm-actions windecor animate";
            preferred_decoration_mode = "server";
          };
          animate = {
            close = "fire";
          };
          input = {
            xkb_layout = "de";
            tap_to_click = false;
            natural_scroll = true;
          };
          vswitch = {
            binding_1 = "<super> KEY_1";
            binding_2 = "<super> KEY_2";
            binding_3 = "<super> KEY_3";
            binding_4 = "<super> KEY_4";
            duration = "300ms circle";
            gap = 20;
            send_win_1 = "<shift> <super> KEY_1";
            send_win_2 = "<shift> <super> KEY_2";
            send_win_3 = "<shift> <super> KEY_3";
            send_win_4 = "<shift> <super> KEY_4";
            wraparound = true;
          };
          simple-tile = {
            inner_gap_size = 4;
            outer_vert_gap_size = 10;
            outer_horiz_gap_size = 4;
          };
          wm-actions = {
            toggle_fullscreen = "<super> KEY_F";
          };
          wrot = {
            reset-one = "<super> <shift> KEY_R";
          };
          windecor = {
            title_position = 0;
          };
          animate = {
            close_animation = "fire";
          };
        };
      };
    };
}
