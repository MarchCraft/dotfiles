{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.rofi.enable = lib.mkEnableOption "install rofi";
  config = lib.mkIf config.marchcraft.rofi.enable {

    home.packages = with pkgs; [
      rbw
      rofi-rbw-wayland
      rofi-power-menu
      rofimoji
      rofi-bluetooth
    ];


    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins =
        let
          rofi-calc-wayland =
            pkgs.rofi-calc.overrideAttrs
              (finalAttrs: previousAttrs:
                let
                  unRofiInputs = lib.lists.remove pkgs.rofi-unwrapped previousAttrs.buildInputs;
                in
                {
                  buildInputs = unRofiInputs ++ [ pkgs.rofi-wayland ];
                });
          rofi-rofimoji-wayland =
            pkgs.rofimoji.overrideAttrs
              (finalAttrs: previousAttrs:
                let
                  unRofiInputs = lib.lists.remove pkgs.rofi-unwrapped previousAttrs.buildInputs;
                in
                {
                  buildInputs = unRofiInputs ++ [ pkgs.rofi-wayland ];
                });
        in
        [
          rofi-calc-wayland
          rofi-rofimoji-wayland
        ];
    };
  };
}
