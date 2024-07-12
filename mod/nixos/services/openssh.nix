{ lib
, config
, sops
, ...
}: {
  options.marchcraft.services.openssh.enable = lib.mkEnableOption "setup impermanence";
  config = lib.mkIf config.marchcraft.services.openssh.enable {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };
}
