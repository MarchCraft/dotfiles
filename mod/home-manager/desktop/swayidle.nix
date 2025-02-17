{
  config,
  lib,
  pkgs,
  ...
}: {
  options.marchcraft.desktop.swayidle.enable = lib.mkEnableOption "install swaylock";
  config = lib.mkIf config.marchcraft.desktop.swayidle.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        effect-blur = "20x3";
        clock = true;
        ignore-empty-password = true;
        daemonize = true;
        show-failed-attempts = true;
        screenshots = true;
      };
    };

    services.swayidle = {
      enable = true;
      events = [
        {
          event = "lock";
          command = "${config.programs.swaylock.package}/bin/swaylock";
        }
        {
          event = "before-sleep";
          command = "${config.programs.swaylock.package}/bin/swaylock; ${pkgs.playerctl}/bin/playerctl pause";
        }
      ];
    };
  };
}
