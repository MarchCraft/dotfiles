{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.marchcraft.desktop.hyprland.enable {
    # these are needed for some of the keybinds. i COULD inline them, but i hate writing
    # the ${pkg}/bin/executable thingy
    home.packages = with pkgs; [
      grim
      slurp
      pamixer
      brightnessctl
    ];

    wayland.windowManager.hyprland = let
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
    in {
      settings.bind = [
        # app shortcuts
        "$mainMod, W, exec, firefox"
        "$mainMod, Return, exec, kitty"
        "$mainMod, R, exec, killall rofi || rofi -show drun"
        "$mainMod SHIFT, C, exec, killall rofi || rofi -show calc -modi calc -no-show-match -no-sort -no-persist-history -calc-command \"echo -n '{result}' | wl-copy\""

        # screenshots
        "$mainMod, P, exec, grim -o eDP-1 ~/Pictures/Screenshots/$(date +%s).png"
        "$mainMod SHIFT, P, exec, grim -g \"\$(slurp)\" ~/Pictures/Screenshots/$(date +%s).png"
        "$mainMod, P, exec, grim -o eDP-1 ~/Pictures/Screenshots/$(date +%s).png"

        "$mainMod, C, killactive, "
        "$mainMod, F, fullscreen, "
        "$mainMod SHIFT, F, fullscreen, 1"

        "$mainMod, J, togglesplit"

        # Swaync
        "$mainMod, N, exec, swaync-client -t -sw"

        # Swaylock-fancy
        "$mainMod, L, exec, swaylock -C ${swaylockConfig}"

        # vim bindings
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, s, togglespecialworkspace, spotify"
        "$mainMod, ssharp, togglespecialworkspace, term"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        #switch monitors
        "$mainMod, u, focusmonitor, +1"
        "$mainMod, i, focusmonitor, -1"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

        # move active window to relative monitor
        "$mainMod SHIFT, i, movewindow, mon:+1"
        "$mainMod SHIFT, u, movewindow, mon:-1"

        # move the whole fucking workspace to a monitor
        "$mainMod SHIFT ALT, i, movecurrentworkspacetomonitor, +1"
        "$mainMod SHIFT ALT, u, movecurrentworkspacetomonitor, -1"

        # swap window with window in direction
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"

        # switch output device
        ", XF86Tools, exec, wp-switch-output"
        ", XF86AudioMedia, exec, wp-switch-output"
        # present
        "$mainMod, o, exec, hyprland-mirror"
        "$mainMod SHIFT, o, exec, killall wl-mirror"
      ];

      extraConfig =
        /*
        hyprlang
        */
        ''
          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          # spotify
          bindl = ,XF86AudioNext, exec, playerctl next
          bindl = ,XF86AudioPrev, exec, playerctl previous
          bindl = ,XF86AudioPlay, exec, playerctl play-pause

          bindl = , XF86AudioLowerVolume, exec, pamixer -d 5
          bindl = , XF86AudioRaiseVolume, exec, pamixer -i 5
          bindl = , XF86AudioMute, exec, pamixer -t

          # backlight controls
          bindle = ,XF86MonBrightnessUp, exec, brightnessctl set 10%+
          bindle = ,XF86MonBrightnessDown, exec, brightnessctl set 10%-

          # keyboard backlights controls
          bindl = $mainMod, XF86MonBrightnessDown, exec, brightnessctl -d kbd_backlight set 10%-
          bindl = $mainMod, XF86MonBrightnessUp, exec, brightnessctl -d kbd_backlight set 10%+

          env = HYPRCURSOR_THEME, HyprCatppuccinMochaMauve
          env = HYPRCURSOR_SIZE, 24

          exec-once = swayidle
          exec-once = gsettings set org.gnome.desktop.interface icon-theme 'Colloid-dark'
          exec-once = swayidle -w before-sleep "swaylock --clock --indicator --screenshots --effect-scale 0.4 --effect-vignette 0.2:0.5 --effect-blur 4x2 --datestr '%a %e.%m.%Y' --timestr '%k:%M'" timeout 300 "swaylock --clock --indicator --screenshots --effect-scale 0.4 --effect-vignette 0.2:0.5 --effect-blur 4x2 --datestr '%a %e.%m.%Y' --timestr '%k:%M'" timeout 360 "hyprctl dispatch dpms off" resume "hyprctl dispatch dpms on" lock "swaylock --clock --indicator --screenshots --effect-scale 0.4 --effect-vignette 0.2:0.5 --effect-blur 4x2 --datestr '%a %e.%m.%Y' --timestr '%k:%M'"
          exec-once = gsettings set org.gnome.desktop.interface cursor-size 24
        '';
    };
  };
}
