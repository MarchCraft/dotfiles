{
  lib,
  config,
  ...
}:
let
  borgbackupMonitor =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    with lib;
    {
      key = "borgbackupMonitor";
      _file = "borgbackupMonitor";
      config.systemd.services =
        {
          "notify-problems@" = {
            enable = true;
            serviceConfig.User = "felix";
            environment.SERVICE = "%i";
            script = ''
              ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE FAILED!" "Run journalctl -u $SERVICE for details"
            '';
          };
        }
        // flip mapAttrs' config.services.borgbackup.jobs (
          name: value:
          nameValuePair "borgbackup-job-${name}" {
            unitConfig.OnFailure = "notify-problems@%i.service";
            preStart = lib.mkBefore ''
              # waiting for internet after resume-from-suspend
              until /run/current-system/sw/bin/ping google.com -c1 -q >/dev/null; do :; done
            '';
          }
        );

      # optional, but this actually forces backup after boot in case laptop was powered off during scheduled event
      # for example, if you scheduled backups daily, your laptop should be powered on at 00:00
      config.systemd.timers = flip mapAttrs' config.services.borgbackup.jobs (
        name: value:
        nameValuePair "borgbackup-job-${name}" {
          timerConfig.Persistent = lib.mkForce true;
        }
      );
    };
in
{
  imports = [ borgbackupMonitor ];
  options.marchcraft.backup = {
    enable = lib.mkEnableOption "Enable backups";
    name = lib.mkOption {
      description = "Name of the backup";
      type = lib.types.str;
      default = config.networking.hostName;
    };
  };
  config = lib.mkIf config.marchcraft.backup.enable {
    services.borgbackup = {
      jobs."${config.marchcraft.backup.name}" = {
        paths = "/home/felix";
        encryption.mode = "none";
        repo = "/mnt/backup/PCs/Felix/borg/${config.marchcraft.backup.name}";
        compression = "auto,lz4";
        startAt = "hourly";
        prune.keep = {
          within = "1d"; # Keep all archives from the last day
          daily = 7;
          weekly = 4;
          monthly = -1; # Keep at least one archive for each month
        };
      };
    };
  };
}
