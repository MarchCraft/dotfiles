{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.marchcraft.desktop.hyprland.enable {
    home.packages = with pkgs; [
      swww
    ];
    wayland.windowManager.hyprland =
      let
        background = pkgs.fetchurl {
          url = "https://4kwallpapers.com/images/wallpapers/bmw-m4-gt4-evo-8k-7680x5023-16981.jpg";
          hash = "sha256-YWqygdVdoHE8CTTuhvjOEbDbM4pss7xZXNfmSvWJroc=";
        };
      in
      {
        extraConfig = ''
          exec-once = sleep 2 && swww init && sleep 1 && swww img --transition-type none ${background}
        '';
      };
  };
}
