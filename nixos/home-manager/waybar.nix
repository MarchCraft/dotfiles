{
    config,
    pkgs,
    inputs,
    ...
}: let
    sharedModules = builtins.fromJSON (builtins.readFile ../../config/waybar/config.json);
    pkgs-stable = import inputs.nixpkgs-stable {
        system = "aarch64-linux";
    };
in {
    home.file = {
        ".config/waybar/style.css".source = ../../config/waybar/style.css;
        ".config/waybar/scripts".source = ../../config/waybar/scripts;
    };


    programs.waybar = {
        package = pkgs-stable.waybar;
        enable = true;
        settings = {
            mainBar = {
                mod= "dock";
                modules-center= [];
                modules-left= [
                    "clock"
                    "custom/weather"
                    "hyprland/workspaces"
                    "custom/agenda"
                    "network"
                ];
                modules-right= [
                    "tray"
                    "cpu"
                    "temperature"
                    "memory"
                    "custom/updates"
                    "custom/language"
                    "battery"
                    "backlight"
                    "pulseaudio"
                    "pulseaudio#microphone"
                ];
            }
            // sharedModules;
        };
    };
}
