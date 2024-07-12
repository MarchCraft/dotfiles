{ config
, lib
, ...
}: {
  options.marchcraft.yazi.enable = lib.mkEnableOption "install the yazi config";

  config = lib.mkIf config.marchcraft.yazi.enable {
    programs.yazi = {
      enable = true;
    };
    wayland.windowManager.hyprland.extraConfig = ''
      bind = $mainMod, E, exec, kitty -e yazi
    '';
  };
}
