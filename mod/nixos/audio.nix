{ config
, lib
, ...
}: {
  options.marchcraft.audio.enable = lib.mkEnableOption "install pipewire";
  config = lib.mkIf config.marchcraft.audio.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
