{
  config,
  lib,
  pkgs,
  ...
}:
let
  sharedModules = builtins.fromJSON (builtins.readFile ../../../../config/waybar/config.json);
in
{
  options.marchcraft.waybar.enable = lib.mkEnableOption "install waybar";
  config = lib.mkIf config.marchcraft.waybar.enable {
    home.packages = with pkgs; [
      (python312.withPackages (python-pkgs: [
        python-pkgs.requests
      ]))
      gcalcli
    ];
    home.file = {
      ".config/waybar/style.css".source = ../../../../config/waybar/style.css;
      ".config/waybar/scripts".source = ../../../../config/waybar/scripts;
    };
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          mod = "dock";
          margin-top = 4;
          margin-bottom = 4;
          modules-center = [ ];
          modules-left = [
            "clock"
            "custom/weather"
            "custom/agenda"
            "network"
          ];
          modules-right = [
            "tray"
            "cpu"
            "temperature"
            "memory"
            "custom/updates"
            "custom/language"
            "battery"
            "backlight"
            "custom/wlinhibit"
            "pulseaudio"
            "pulseaudio#microphone"
          ];
        } // sharedModules;
      };
    };
    wayland.windowManager.hyprland.extraConfig = ''
      exec-once = waybar
    '';
  };
}
