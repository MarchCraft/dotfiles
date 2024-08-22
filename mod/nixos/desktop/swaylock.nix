{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.desktop.swaylock.enable = lib.mkEnableOption "install swaylock";
  config = lib.mkIf config.marchcraft.desktop.swaylock.enable {



    security.pam.services.swaylock = {
      text = ''
        auth sufficient pam_fprintd.so
        auth include login
      '';
    };
  };
}
