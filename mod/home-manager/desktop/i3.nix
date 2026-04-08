{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.marchcraft.desktop.i3 = {
    enable = lib.mkEnableOption "install the river config";
  };

  config = lib.mkIf config.marchcraft.desktop.i3.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        terminal = "kitty";
      };
    };
  };
}
