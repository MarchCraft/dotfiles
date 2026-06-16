{
  config,
  lib,
  ...
}:
{
  options.marchcraft.audio.enable = lib.mkEnableOption "install pipewire";
  config = lib.mkIf config.marchcraft.audio.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.avahi.enable = true;

    services.pulseaudio.zeroconf.discovery.enable = true;

    services.pipewire.extraConfig.pipewire."90-zeroconf-discover" = {
      "context.modules" = [
        {
          name = "libpipewire-module-zeroconf-discover";
        }
      ];
    };
  };
}
