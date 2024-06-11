{ config, lib, pkgs, ... }:
{
    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
        kitty
        firefox
        stable.swayidle
        stable.swaylock-effects
        slurp
        grim
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal-xapp
        xdg-desktop-portal-gnome
        xdg-desktop-portal-wlr
        rofi-bluetooth
        rofi-vpn
        rofimoji
        rofi-pass-wayland
        swww
        brightnessctl
        wlogout
        wl-mirror
        swaynotificationcenter
        hyprcursor
        hyprlock
        wl-mirror
        wlinhibit
        ags
    ];

    security.pam.services.swaylock = {
        text = ''
            auth sufficient pam_fprintd.so
            auth include login
            '';
    };

    # greetd
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
            default_session = let
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
            in {
                command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprlandConfig}";
            };
        };
    };
}
