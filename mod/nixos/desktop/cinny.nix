{
  config,
  lib,
  pkgs,
  ...
}: {
  options.marchcraft.desktop.cinny.enable = lib.mkEnableOption "install cinny";
  config = lib.mkIf config.marchcraft.desktop.cinny.enable {
    systemd.services."cinny" = {
      description = "Serve element";
      after = ["network.target"];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.caddy}/bin/caddy file-server -r ${pkgs.master.cinny-unwrapped} --listen :80";
        Restart = "always";
        RestartSec = 5;
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
