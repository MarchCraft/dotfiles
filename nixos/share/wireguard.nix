{ config, lib, pkgs, ... }:

{
    networking.firewall = {
        allowedUDPPorts = [ 59536 ]; 
    };

    sops.secrets.wiregurard_private_key = {
        format = "binary";
        sopsFile = ../../secrets/wireguard_private_key;
    };

    sops.secrets.wireguard_psk = {
        format = "binary";
        sopsFile = ../../secrets/wireguard_psk;
    };

    networking.wg-quick.interfaces = {
        wg0 = {
            address = [ "10.66.66.2/32" "fd42:42:42::2/128" ];
            dns = [ "1.1.1.1" ];

            listenPort = 59536;

            privateKeyFile = "/run/secrets/wireguard_private_key";

            peers = [
            {
                publicKey = "ZhivZiWl/EMDte9vIXgYs1TBHcjY1HZKY/s7UfSgkRw=";
                allowedIPs = [ "0.0.0.0/0, ::/0" ];
                endpoint = "vpn.nilles.dynv6.net:59536";
                presharedKeyFile = "/run/secrets/wireguard_psk";
                persistentKeepalive = 25;
            }
            ];
        };
    };
}
