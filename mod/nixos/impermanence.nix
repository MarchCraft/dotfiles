{ config
, lib
, inputs
, ...
}: {
  options.marchcraft.impermanence_system.enable = lib.mkEnableOption "install the imper config";

  config = lib.mkIf config.marchcraft.impermanence_system.enable {
    programs.fuse.userAllowOther = true;

    services.openssh.hostKeys = [
      {
        bits = 4096;
        path = "/persist/system/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/persist/system/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    environment.persistence."/persist/system" = {
      hideMounts = true;
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/var/cache/regreet/cache.toml"
      ];
      directories = [
        "/var/lib/systemd/backlight"
        "/var/lib/tailscale"
      ];

    };

  };
}
