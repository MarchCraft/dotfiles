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
    secretsFile2 = lib.mkOption {
      type = lib.types.path;
      description = "Path to the private key file for the WireGuard interface.";
    };
    secretsFile3 = lib.mkOption {
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

      sops.secrets.wireguard-client2 = {
        format = "binary";
        sopsFile = opts.secretsFile2;
      };

      sops.secrets.wireguard-client3 = {
        format = "binary";
        sopsFile = opts.secretsFile3;
      };

      networking.wireguard.interfaces = {
        # wg0 = {
        #   ips = [ "${opts.ip}/24" ];
        #   listenPort = 51820;
        #
        #   privateKeyFile = "${config.sops.secrets.wireguard-client.path}";
        #
        #   peers = [
        #     {
        #       publicKey = "ec10Bfi+qCpHGyUtwkPkFKKYggUIaOf+r10el9pKMyQ=";
        #
        #       allowedIPs = [ "100.10.0.0/24" ];
        #
        #       endpoint = "78.46.251.145:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
        #
        #       persistentKeepalive = 25;
        #     }
        #   ];
        # };
        wg0 = {
          ips = [ "10.11.12.4/24" ];
          listenPort = 51820;

          privateKeyFile = "${config.sops.secrets.wireguard-client2.path}";

          peers = [
            {
              publicKey = "EJmqUzZLX3nEHXST7+q4FSAOUtCQ8hie0tyS9KLIIQM=";

              allowedIPs = [
                "100.10.0.0/24"
                "134.99.154.0/24"
              ];

              endpoint = "134.99.154.242:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

              presharedKeyFile = "${config.sops.secrets.wireguard-client3.path}";

              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
}
