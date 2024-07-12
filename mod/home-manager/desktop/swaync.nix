{ config
, lib
, ...
}: {
  options.marchcraft.desktop.swaync.enable = lib.mkEnableOption "install swaync";
  config = lib.mkIf config.marchcraft.desktop.swaync.enable {
    services.swaync = {
      enable = true;
    };
  };
}
