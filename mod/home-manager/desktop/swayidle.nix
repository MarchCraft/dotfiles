{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.desktop.swayidle.enable = lib.mkEnableOption "install swaylock";
  config = lib.mkIf config.marchcraft.desktop.swayidle.enable {

    services.swayidle = {
      enable = true;
      timeouts = [
        { timeout = 300; command = "${pkgs.swaylock-fancy}/bin/swaylock-fancy"; }
        { timeout = 360; command = "hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on"; }
      ];
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock-fancy}/bin/swaylock-fancy"; }
        { event = "lock"; command = "${pkgs.swaylock-fancy}/bin/swaylock-fancy"; }
      ];
    };
  };
}
