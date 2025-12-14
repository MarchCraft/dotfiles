{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.marchcraft.services.wireguard = {
    enable = lib.mkEnableOption "wireguard client";
    ip = lib.mkOption {
      type = lib.types.str;
      description = "The IP address of the client to use for the WireGuard interface.";
    };
    secretsFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the private key file for the WireGuard interface.";
    };
  };
  config =
    let
      opts = config.marchcraft.services.wireguard;
    in
    lib.mkIf opts.enable {
      networking.firewall = {
        allowedUDPPorts = [ 51820 ];
      };

      sops.secrets.wireguard-client = {
        format = "binary";
        sopsFile = opts.secretsFile;
      };

      networking.wireguard.interfaces = {
        wg0 = {
          ips = [ "${opts.ip}/24" ];
          listenPort = 51820;

          privateKeyFile = "${config.sops.secrets.wireguard-client.path}";

          peers = [
            {
              publicKey = "ec10Bfi+qCpHGyUtwkPkFKKYggUIaOf+r10el9pKMyQ=";

              allowedIPs = [ "100.10.0.0/24" ];

              endpoint = "78.46.251.145:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
}
