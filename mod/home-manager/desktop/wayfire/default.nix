{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.desktop.wayfire = {
    enable = lib.mkEnableOption "install the wayfire config";
    scale = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "The scale for the output";
    };
    keyboard_layout = lib.mkOption {
      type = lib.types.string;
      default = "de";
      description = "The keyboard layout";
    };
    super_key = lib.mkOption {
      type = lib.types.string;
      default = "super";
      description = "The super key";
    };
  };


  config =
    let
      super_key = config.marchcraft.desktop.wayfire.super_key;
    in
    lib.mkIf config.marchcraft.desktop.wayfire.enable
      {
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

        wayland.windowManager.wayfire = {
          enable = true;
          plugins = [
            pkgs.wayfirePlugins.wcm
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
                binding_0 = "<${super_key}> KEY_ENTER";
                command_0 = "kitty -e tmux attach || tmux";
                binding_1 = "<${super_key}> KEY_W";
                command_1 = "firefox";
                binding_2 = "<${super_key}> KEY_R";
                command_2 = "rofi -show drun -show-icons";
                binding_3 = "<${super_key}> <shift> KEY_L";
                command_3 = "swaylock -C ${swaylockConfig}";
                binding_4 = "<${super_key}> KEY_M";
                command_4 = "wlogout";

                binging_100 = "XF86AudioMute";
                command_100 = "pamixer -t";
                binding_101 = "XF86AudioLowerVolume";
                command_101 = "pamixer -d 5";
                binding_102 = "XF86AudioRaiseVolume";
                command_102 = "pamixer -i 5";

                binding_103 = "XF86MonBrightnessDown";
                command_103 = "brightnessctl set 10%-";
                binding_104 = "XF86MonBrightnessUp";
                command_104 = "brightnessctl set 10%+";

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
              };
            output = {
              depth = 8;
              mode = "auto";
              position = "auto";
              scale = config.marchcraft.desktop.wayfire.scale;
              transform = "normal";
              vrr = true;
            };
            core = {
              close_top_view = "<${super_key}> KEY_C";
              plugins = "alpha animate autostart command cube expo fast-switcher fisheye foreign-toplevel gtk-shell idle invert move oswitch place resize shortcuts-inhibit switcher vswitch wayfire-shell window-rules wobbly wrot zoom simple-tile vswipe wm-actions view-shot session-lock hide-cursor decoration ipc pixdecor";
            };
            input = {
              xkb_layout = config.marchcraft.desktop.wayfire.keyboard_layout;
              tap_to_click = false;
              natural_scroll = true;
            };
            vswitch = {
              binding_1 = "<${super_key}> KEY_1";
              binding_2 = "<${super_key}> KEY_2";
              binding_3 = "<${super_key}> KEY_3";
              binding_4 = "<${super_key}> KEY_4";
              duration = "300ms circle";
              gap = 20;
              send_win_1 = "<shift> <${super_key}> KEY_1";
              send_win_2 = "<shift> <${super_key}> KEY_2";
              send_win_3 = "<shift> <${super_key}> KEY_3";
              send_win_4 = "<shift> <${super_key}> KEY_4";
              wraparound = true;
            };
            simple-tile = {
              inner_gap_size = 4;
              outer_vert_gap_size = 10;
              outer_horiz_gap_size = 4;
            };
            wm-actions = {
              toggle_fullscreen = "<${super_key}> KEY_F";
            };
            wrot = {
              reset-one = "<${super_key}> <shift> KEY_R";
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
