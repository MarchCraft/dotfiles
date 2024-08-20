{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.greeter.enable = lib.mkEnableOption "enable the greeter";

  config = lib.mkIf config.marchcraft.greeter.enable {
    environment.systemPackages = with pkgs; [
      greetd.wlgreet
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session =
          let
            hyprlandConfig = builtins.toFile "sway.regreet.conf" ''
              exec "wlgreet --command sway; swaymsg exit"

              bindsym Mod4+shift+e exec swaynag \
              	-t warning \
              	-m 'What do you want to do?' \
              	-b 'Poweroff' 'systemctl poweroff' \
              	-b 'Reboot' 'systemctl reboot'

              include /etc/sway/config.d/*

            '';
          in
          {
            command = "${pkgs.sway}/bin/sway --config ${hyprlandConfig}";
          };
      };
    };
  };
}
