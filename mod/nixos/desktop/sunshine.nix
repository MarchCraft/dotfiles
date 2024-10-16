{ config
, pkgs
, lib
, ...
}: {
  options.marchcraft.desktop.remotePlay = {
    enable = lib.mkEnableOption "install remoteplay";
  };

  config =
    let
      opts = config.marchcraft.desktop.remotePlay;
    in
    lib.mkIf opts.enable {
      services.sunshine = {
        enable = true;
        openFirewall = true;
        capSysAdmin = true;
        applications.apps = [
          {
            name = "PrismLauncher";
            cmd = "${pkgs.prismlauncher}/bin/prismlauncher";
            auto-detach = "true";
          }
        ];
      };
    };
}
