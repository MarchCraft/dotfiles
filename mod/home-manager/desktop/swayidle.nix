{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.desktop.swayidle.enable = lib.mkEnableOption "install swaylock";
  config = lib.mkIf config.marchcraft.desktop.swayidle.enable {

    services.swayidle =
      let
        swaylockConfig = builtins.toFile "swaylock.conf" ''
          daemonize
          screenshots
          clock
          indicator
          indicator-radius=100
          indicator-thickness=7
          effect-blur=7x5
          effect-vignette=0.5:0.5
          ring-color=bb00cc
          key-hl-color=880033
          line-color=00000000
          inside-color=00000088
          separator-color=00000000
        '';
      in
      {
        enable = true;
        timeouts = [
          { timeout = 60; command = "${pkgs.swaylock-effects}/bin/swaylock -C ${swaylockConfig}"; }
          { timeout = 70; command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"''; resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"''; }
        ];
        events = [
          { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -C ${swaylockConfig}"; }
          { event = "lock"; command = "${pkgs.swaylock-effects}/bin/swaylock -C ${swaylockConfig}"; }
        ];
      };
  };
}
