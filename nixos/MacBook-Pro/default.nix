{ inputs
, outputs
, config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../locale.nix

    inputs.sops.nixosModules.sops
    inputs.hm.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index
    inputs.apple-silicon-support.nixosModules.apple-silicon-support
    inputs.impermanence.nixosModules.impermanence
    inputs.nur.nixosModules.nur

    outputs.nixosModules.marchcraft
  ];

  environment.systemPackages = [
    #pkgs.tailscale
    #pkgs.cinny-desktop
    #pkgs.element-desktop-wayland
  ];

  services.tailscale.enable = true;

  sops.secrets.felix_pwd = {
    format = "binary";
    sopsFile = ../secrets/felix_pwd;
    neededForUsers = true;
  };

  nixpkgs.config.allowUnsupportedSystem = true;

  marchcraft.bootconfig.enable = true;
  marchcraft.nixconfig.enable = true;
  security.polkit.enable = true;

  marchcraft.users.felix = {
    shell = pkgs.fish;
    extraGroups = [ "wheel" "docker" ];
    hashedPasswordFile = config.sops.secrets.felix_pwd.path;
    home-manager = {
      enable = true;
      config = ../home-manager/MacBook-Pro-felix.nix;
    };
  };

  marchcraft.services.wifi = {
    enable = true;
    secretsFile = ../secrets/wifi;
    hhuEduroam = true;
    networks = [
      "MonkeyIsland"
      "HHUD-Y"
      "iPhoneF"
      "WIFI@DB"
      "Nothing Phone (2)"
    ];
  };
  marchcraft.services.printing.enable = true;

  marchcraft.impermanence_system.enable = true;

  marchcraft.greeter.enable = true;
  marchcraft.desktop.swaylock.enable = true;

  marchcraft.audio.enable = true;
  marchcraft.misc.enable = true;

  marchcraft.services.openssh.enable = true;
  marchcraft.services.pika.enable = true;
  marchcraft.services.yubikey.enable = true;
  marchcraft.services.mac-spoofing = {
    enable = false;
    interface = "wlp1s0f0";
  };

  networking.hostName = "MacBook-Pro";

  users.defaultUserShell = pkgs.fish;

  programs.fish.enable = true;

  environment.shellAliases = {
    ls = null;
    ll = null;
    l = null;
  };

  users.users."felix".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqlr0nKMcn6rZE0hn8RyzfgT75IxKwzgPn59WH1TSdskJNwRJh5UEDKtHA3eSxguWVdJqSDtbDeO7D6pofqPxMarhCoQwa79056e2LtDYVrABTQPabRSTreHDbMekj6RsxdHAg2BFayutEVwHHRKBuyK3DQd5hu4P3DM9t3c5Zd4XEUY4wB0N2EYy56/kw7uUM49dCX10GLSFVivVyUmb3IpFLmOt7s5I64JpsU5NGG4VdrsRJlG2U2q8f3PWf8tIhqONtR+wa7AYOKKGmBBuq7I1qX3lE7+sgxUc9CFfHVC8+OLclnCizlJaiqXIN+K35URyrqxY5Wf7POeSfhewB florian@yubikey"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDF5vhkEdRPrHHLgCMxm0oSrHU+uPM9W45Kdd/BKGreRp5vAA70vG3xEjzGdzIlhF0/qOZisA3MpjnMhW3l+uogTzuD3vDZdgT/pgoZEy2CIGIp9kbK5pQHhEhMbWi5NS5o8F095ZZRjBwRE1le9GmBZbYj3VUHSVaRxv+gZpSdqKBo9Arvr4L/lyTdpYgGEHUParWX+UtkBXSd0mO91h6XM8hEqLJv+ufbgA4az0O8sNTz2Uh+k3kN2sQn11O3ekGk4M9fpDP9+C17C9fbMpMATbFazl5pWnPqgLPrvNCs8dkKEJCRPgTgXHYaOppZ7hprJvMpOYW/IYyYo/1T2j6ELZJ7apMJNlOhWqVDnM5DGSIf65oNGZLiAupq1X+s6IoSEZOcAuWfTlJgRySdNgh/BSiKvmKG0nK8/z2ERN0/shE9/FT7pMyEfxHzNdl4PMvpPKZkucX1z4Pb3DtR684WRxD94lj5Nqh/3CH0EeLMJPwyFsOBNdsitqZGLHpGbOLZ3VDdjbOl2Qjgyl/VwzhAWNYUpyxZj3ZpFlHyDE0y38idXG7L0679THKzE62ZAnPdHHTP5RdWtRUqpPyO/nVXErOr8j55oO27C6jD0n5L4tU3QgSpjMOvomk9hbPzKEEuDGG++gSj9JoVHyAMtkWiYuamxR1UY1PlYBskC/q77Q== openpgp:0xB802445D"
  ];


  system.stateVersion = "23.11";
}
