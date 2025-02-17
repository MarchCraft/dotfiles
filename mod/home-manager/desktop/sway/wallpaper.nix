{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.marchcraft.desktop.sway.enable {
    home.packages = with pkgs; [
      swww
    ];
    wayland.windowManager.sway = let
      background = pkgs.fetchurl {
        url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nixos-wallpaper-catppuccin-mocha.png?raw=true";
        hash = "sha256-fmKFYw2gYAYFjOv4lr8IkXPtZfE1+88yKQ4vjEcax1s=";
      };
    in {
      extraConfig = ''
        exec "swww init && swww img --transition-type none ${background}"
      '';
    };
  };
}
