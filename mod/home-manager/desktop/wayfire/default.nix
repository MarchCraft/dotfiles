{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.marchcraft.desktop.wayfire = {
    enable = lib.mkEnableOption "install the wayfire config";
    scale = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "The scale for the output";
    };
    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "de";
      description = "The keyboard layout";
    };
    superKey = lib.mkOption {
      type = lib.types.str;
      default = "super";
      description = "The super key";
    };
  };

  config =
    let
      superKey = config.marchcraft.desktop.wayfire.superKey;
    in
    lib.mkIf config.marchcraft.desktop.wayfire.enable {
      home.packages = with pkgs; [
        grim
        slurp
        pamixer
        brightnessctl
        wlinhibit
        xdg-desktop-portal-wlr
        wl-clipboard
        grim
        slurp
      ];

      wayland.windowManager.wayfire = {
        enable = true;
        plugins = [
          pkgs.wayfirePlugins.wcm
        ];
        settings = {
          command = {
            binding_0 = "<${superKey}> KEY_ENTER";
            command_0 = "kitty -e tmux attach || tmux";
            binding_1 = "<${superKey}> KEY_W";
            command_1 = "firefox";
            binding_2 = "<${superKey}> KEY_R";
            command_2 = "rofi -show drun -show-icons";
            binding_3 = "<${superKey}> <shift> KEY_L";
            command_3 = "loginctl lock-session";
            binding_4 = "<${superKey}> KEY_M";
            command_4 = lib.getExe pkgs.wlogout;

            binding_volume_mute = "KEY_MUTE";
            command_volume_mute = "pamixer -t";
            repeatable_binding_volume_down = "KEY_VOLUMEDOWN";
            command_volume_down = "pamixer -d 5";
            repeatable_binding_volume_up = "KEY_VOLUMEUP";
            command_volume_up = "pamixer -i 5";

            binding_103 = "XF86MonBrightnessDown";
            command_103 = "brightnessctl set 10%-";
            binding_104 = "XF86MonBrightnessUp";
            command_104 = "brightnessctl set 10%+";
          };

          autostart = {
            autostart = "swaync";
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
            close_top_view = "<${superKey}> KEY_C";
            plugins = "autostart command cube expo fisheye foreign-toplevel switcher vswitch wobbly wrot simple-tile wm-actions decoration animate";
          };

          input = {
            xkb_layout = config.marchcraft.desktop.wayfire.keyboardLayout;
            tap_to_click = false;
            natural_scroll = true;
          };

          vswitch = {
            binding_1 = "<${superKey}> KEY_1";
            binding_2 = "<${superKey}> KEY_2";
            binding_3 = "<${superKey}> KEY_3";
            binding_4 = "<${superKey}> KEY_4";
            duration = "300ms circle";
            gap = 20;
            send_win_1 = "<shift> <${superKey}> KEY_1";
            send_win_2 = "<shift> <${superKey}> KEY_2";
            send_win_3 = "<shift> <${superKey}> KEY_3";
            send_win_4 = "<shift> <${superKey}> KEY_4";
            wraparound = true;
          };

          simple-tile = {
            inner_gap_size = 4;
            outer_vert_gap_size = 10;
            outer_horiz_gap_size = 4;
          };

          wm-actions = {
            toggle_fullscreen = "<${superKey}> KEY_F";
          };

          decoration = {
            title_height = 0;
          };

          cube = {
            activate = "<${superKey}> <shift> BTN_LEFT";
            rotate_left = "<${superKey}> <alt> KEY_H";
            rotate_right = "<${superKey}> <alt> KEY_L";
            background_mode = "skydome";
          };

          wrot = {
            reset-one = "<${superKey}> <shift> KEY_R";
          };

          animate = {
            close_animation = "fire";
          };
        };
      };
    };
}
