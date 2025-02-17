{
  lib,
  config,
  ...
}: {
  options.marchcraft.services.printing.enable = lib.mkEnableOption "setup printing";
  config = lib.mkIf config.marchcraft.services.printing.enable {
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
