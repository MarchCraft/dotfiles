{
  lib,
  config,
  pkgs,
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
    let
      user = "felix";
      uid = config.users.users.${user}.uid;
    in
    with lib;
    {
      key = "borgbackupMonitor";
      _file = "borgbackupMonitor";

      config = {

        systemd.services =
          let
            # Notify Service
            notifyService = {
              "notify-problems@" = {
                description = "Desktop notification for failed service %i";

                serviceConfig = {
                  Type = "oneshot";
                  User = user;
                  Environment = [
                    "XDG_RUNTIME_DIR=/run/user/${toString uid}"
                    "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString uid}/bus"
                  ];
                };

                script = ''
                  ${pkgs.libnotify}/bin/notify-send \
                    -u critical \
                    "Service %N failed" \
                    "Run: journalctl -u %N -e"
                '';
              };
            };

            # Borg Modifications
            borgFailureHooks = flip mapAttrs' config.services.borgbackup.jobs (
              name: _:
              nameValuePair "borgbackup-job-${name}" {
                unitConfig.OnFailure = "notify-problems@%n.service";

                preStart = mkBefore ''
                  until ${pkgs.iputils}/bin/ping -c1 -q google.com >/dev/null; do
                    sleep 2
                  done
                '';
              }
            );

          in
          notifyService // borgFailureHooks;

        systemd.timers = flip mapAttrs' config.services.borgbackup.jobs (
          name: _:
          nameValuePair "borgbackup-job-${name}" {
            timerConfig.Persistent = mkForce true;
          }
        );

        users.users.${user}.linger = true;
      };
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

    passFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the pass file for encryption";
    };
  };

  config = lib.mkIf config.marchcraft.backup.enable {

    sops.secrets.borg-backup-pass = {
      owner = "felix";
      sopsFile = config.marchcraft.backup.passFile;
      format = "binary";
    };

    services.borgbackup.jobs =
      let
        common-excludes = [
          ".cache"
          "*/cache2"
          "*/Cache"
          ".config/Slack/logs"
          ".config/Code/CachedData"
          ".container-diff"
          ".npm/_cacache"
          "*/node_modules"
          "*/bower_components"
          "*/_build"
          "*/.tox"
          "*/venv"
          "*/.venv"
        ];

        basicBorgJob = name: {
          encryption.mode = "repokey-blake2";
          encryption.passCommand = "cat ${config.sops.secrets.borg-backup-pass.path}";

          environment.BORG_RSH = "ssh -i /home/felix/.ssh/id_ed25519";

          extraCreateArgs = "--verbose --stats --checkpoint-interval 600";

          repo = "ssh://backup@10.42.30.40/backups/Felix/${name}";

          compression = "lz4";
          startAt = "hourly";
          user = "felix";
          prune = {
            keep = {
              within = "1d"; # keep all hourly backups for 1 day
              daily = 7; # keep 7 daily backups
              weekly = 4; # keep 4 weekly backups
              monthly = 12; # keep 12 monthly backups (~1 year)
            };
          };
        };
      in
      {
        backup = basicBorgJob "${config.marchcraft.backup.name}" // rec {
          paths = "/home/felix";

          exclude = map (x: paths + "/" + x) (common-excludes ++ [ "Downloads" ]);
        };
      };
  };
}
