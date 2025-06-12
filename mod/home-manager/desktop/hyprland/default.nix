{
  config,
  lib,
  pkgs,
  pkgs-master,
  inputs,
  ...
}:
{
  imports = [
    ./keybinds.nix
  ];

  options.marchcraft.desktop.hyprland = {
    enable = lib.mkEnableOption "install the hyprland config";
    cursor_warps = lib.mkEnableOption "enable cursor warps";
    keyboard_layout = lib.mkOption {
      type = lib.types.str;
      default = "de";
    };
  };

  config = lib.mkIf config.marchcraft.desktop.hyprland.enable {
    home.packages = with pkgs-master; [
      wlinhibit
      wl-clipboard
      hyprcursor
      nvidia-vaapi-driver
    ];

    wayland.windowManager.hyprland = {
      extraConfig = ''
        exec-once = swaync
        exec-once = pkill gpg-agent
        exec-once = gpg-agent --pinentry-program=/usr/bin/pinentry-qt4 --daemon > /dev/null 2>&1
        env = LIBVA_DRIVER_NAME,nvidia
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        env = NVD_BACKEND,direct
        windowrulev2 = float, title:^(Picture in picture)$
        windowrulev2 = pin, title:^(Picture in picture)$
      '';
      enable = true;
      settings = {
        "$mainMod" = "SUPER";
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];

        general = {
          layout = "dwindle";
          border_size = 2;
          gaps_in = 2;
          gaps_out = 2;
        };

        cursor = {
          no_warps = !config.marchcraft.desktop.hyprland.cursor_warps;
          inactive_timeout = 0;
        };

        misc = {
          disable_hyprland_logo = true;
        };

        input = {
          kb_layout = config.marchcraft.desktop.hyprland.keyboard_layout;
          kb_options = "caps:escape";

          follow_mouse = 1;
          sensitivity = 0.1;
          numlock_by_default = true;

          touchpad = {
            natural_scroll = true;
            clickfinger_behavior = 1;
            tap-to-click = false;
            scroll_factor = 0.5;
            tap-and-drag = false;
          };
        };

        xwayland = {
          force_zero_scaling = true;
        };

        decoration = {
          rounding = 10;
          inactive_opacity = 0.95;
          blur.size = 3;
        };

        animations = {
          enabled = true;
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
            "specialWorkspace, 1, 6, default, slidevert"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_forever = true;
        };
      };
    };
  };
}
