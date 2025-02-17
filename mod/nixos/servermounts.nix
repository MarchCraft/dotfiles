{
  lib,
  config,
  inputs,
  ...
}: {
  options.marchcraft.servermounts = {
    enable = lib.mkEnableOption "Enable server mounts";
  };
  config = lib.mkIf config.marchcraft.servermounts.enable {
    sops.secrets.servermounts_rz = {
      sopsFile = ../../nixos/secrets/rz;
      format = "binary";
    };
    fileSystems."/mnt/backup" = {
      device = "//100.64.0.2/Datensicherung";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in ["${automount_opts},credentials=${config.sops.secrets.servermounts_rz.path},uid=${toString config.users.users.felix.uid},gid=${toString config.users.groups.users.gid}"];
    };
  };
}
