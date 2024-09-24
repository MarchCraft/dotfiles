{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.greeter = {
    enable = lib.mkEnableOption "enable the greeter";
    hyprland = lib.mkEnableOption "enable hyprland greeter";
  };
  config = lib.mkIf config.marchcraft.greeter.enable {
    environment.systemPackages = with pkgs; [
      greetd.wlgreet
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session =
          if config.marchcraft.greeter.hyprland
          then
            let
              hyprlandConfig = builtins.toFile "sway.regreet.conf" ''
                exec-once = wlgreet --command Hyprland; hyprctl exit
              '';
            in
            {
              command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprlandConfig}";
            }
          else
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
