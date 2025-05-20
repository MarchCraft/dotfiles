{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.marchcraft.desktop.apps.ghostty = {
    enable = lib.mkEnableOption "install the ghostty config";
  };

  config = lib.mkIf config.marchcraft.desktop.apps.ghostty.enable {
    home.packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-emoji
    ];

    programs.ghostty = {
      enable = true;

      settings = {
        confirm-close-surface = false;
      };
    };
  };
}
