{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.marchcraft.services.wireguard = {
    enable = lib.mkEnableOption "wireguard client";
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

      sops.secrets.wireguard-private-key = {
        sopsFile = opts.secretsFile;
        key = "private-key";
      };

      sops.secrets.wireguard-psk = {
        sopsFile = opts.secretsFile;
        key = "preshared-key";
      };

      sops.secrets.wireguard-asta-private-key = {
        sopsFile = opts.secretsFile;
        key = "asta-private-key";
      };

      sops.secrets.wireguard-proton-private-key = {
        sopsFile = opts.secretsFile;
        key = "proton-private-key";
      };

      sops.secrets.wireguard-asta-psk = {
        sopsFile = opts.secretsFile;
        key = "asta-preshared-key";
      };

      networking.wg-quick.interfaces.wg0 = {
        address = [ "172.16.0.101/32" ];

        autostart = true;

        listenPort = 51820;

        privateKeyFile = config.sops.secrets.wireguard-private-key.path;

        peers = [
          {
            # vps
            publicKey = "ec10Bfi+qCpHGyUtwkPkFKKYggUIaOf+r10el9pKMyQ=";
            presharedKeyFile = config.sops.secrets.wireguard-psk.path;
            allowedIPs = [
              "172.16.0.1/32"
              "10.42.0.0/16"
            ];
            persistentKeepalive = 25;
            endpoint = "vpn.xalir.net:51820";
          }
        ];
      };

      networking.wg-quick.interfaces.wg1 = {
        address = [
          "10.11.12.4/32"
          "fdfd:d3ad:c0de:1234::4/128"
        ];

        autostart = false;

        listenPort = 51820;

        privateKeyFile = config.sops.secrets.wireguard-asta-private-key.path;

        peers = [
          {
            # vps
            publicKey = "EJmqUzZLX3nEHXST7+q4FSAOUtCQ8hie0tyS9KLIIQM=";
            presharedKeyFile = config.sops.secrets.wireguard-asta-psk.path;
            allowedIPs = [
              "10.11.12.0/24"
              "fdfd:d3ad:c0de:1234::/64"
              "134.99.154.0/24"
            ];
            persistentKeepalive = 25;
            endpoint = "134.99.154.242:51820";
          }
        ];
      };

      networking.wg-quick.interfaces.wg2 = {
        address = [
          "10.2.0.2/32"
          "2a07:b944::2:2/128"
        ];

        dns = [
          "10.2.0.1"
          "2a07:b944::2:1"
        ];

        autostart = false;

        listenPort = 51820;

        privateKeyFile = config.sops.secrets.wireguard-proton-private-key.path;

        peers = [
          {
            # vps
            publicKey = "RxTOGGgZ2B+YEmqV+uJDWb2vlcFTi9FYK5gwKBHEbSo=";
            allowedIPs = [
              "0.0.0.0/0"
              "::/0"
            ];
            persistentKeepalive = 25;
            endpoint = "79.127.141.1:51820";
          }
        ];
      };

    };
}
