{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.marchcraft.services.pika = {
    enable = lib.mkEnableOption "install the pika backup tool";
  };
  config = lib.mkIf config.marchcraft.services.pika.enable {
    environment.systemPackages = [
      pkgs.pika-backup
    ];
  };
}
