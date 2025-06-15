{ config, pkgs, ... }:

{
  networking = {
    interfaces.enp7s0f0.useDHCP = true; # WAN
    interfaces.enp7s0f1.ipv4.addresses = [
      {
        address = "10.100.1.1";
        prefixLength = 24;
      }
    ];

    nat = {
      enable = true;
      externalInterface = "enp7s0f0"; # Interface to the internet
      internalInterfaces = [ "enp7s0f1" ]; # Internal LAN
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [ 67 ]; # DHCP-Server-Port
    };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "enp7s0f1";
      dhcp-range = "10.100.1.10,10.100.1.100,12h";
      dhcp-option = [
        "option:router,10.100.1.1"
        "option:dns-server,172.19.0.2"
      ];
      dhcp-leasefile = "/var/lib/misc/dnsmasq.leases";
    };
  };

  services.resolved.enable = false;
}
