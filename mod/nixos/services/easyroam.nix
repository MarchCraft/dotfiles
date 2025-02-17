{
  lib,
  config,
  ...
}:
{
  options.marchcraft.services.easyroam.enable = lib.mkEnableOption "setup easyroam";
  config = lib.mkIf config.marchcraft.services.easyroam.enable {
    sops.secrets.easyroam = {
      format = "binary";
      sopsFile = ../../../nixos/secrets/easyroam;
    };

    services.easyroam = {
      enable = true;
      pkcsFile = config.sops.secrets.easyroam.path;
      wpa-supplicant = {
        enable = true;
      };
    };
  };
}
