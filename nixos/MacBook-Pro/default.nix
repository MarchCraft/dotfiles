{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../locale.nix
    ../share/nixos.nix

    inputs.sops.nixosModules.sops
    inputs.hm.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index
    inputs.apple-silicon-support.nixosModules.apple-silicon-support
    inputs.impermanence.nixosModules.impermanence
    inputs.nur.modules.nixos.default
    inputs.nix-easyroam.nixosModules.nix-easyroam
    inputs.stylix.nixosModules.stylix

    outputs.nixosModules.marchcraft
  ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
  boot.loader.grub.fontSize = 48;
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
  programs.nix-ld.enable = true;

  sops.secrets.nix-conf = {
    sopsFile = ../secrets/nix-conf;
    mode = "444";
    format = "binary";
  };

  boot = {
    plymouth = {
      enable = true;
    };
  };

  sops.secrets.felix_pwd = {
    format = "binary";
    sopsFile = ../secrets/felix_pwd;
    neededForUsers = true;
  };

  marchcraft.bootconfig.enable = true;
  marchcraft.nixconfig.enable = true;
  marchcraft.nixconfig.allowUnfree = true;
  security.polkit.enable = true;

  marchcraft.users.felix = {
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "docker"
    ];
    hashedPasswordFile = config.sops.secrets.felix_pwd.path;
    home-manager = {
      enable = true;
      config = ../home-manager/MacBook-Pro-felix.nix;
    };
  };

  marchcraft.services.wifi = {
    enable = true;
    secretsFile = ../secrets/wifi;
    networks = {
      "iPhone von Felix" = "FelixPhonePass";
      HHUD-Y = "HHUDY";
      MonkeyIsland = "MonkeyIsland";
      "99 Problems but WiFi ain't one" = "99Problems";
      LAN5 = "Rauer";
      "UdoLandenberg" = "UdoLandenberg";
      "WiFi Winkler" = { };
    };
  };

  marchcraft.services.printing.enable = true;

  marchcraft.audio.enable = true;
  marchcraft.misc.enable = true;
  marchcraft.servermounts.enable = true;
  marchcraft.backup.enable = true;

  marchcraft.services.openssh.enable = true;
  marchcraft.services.pika.enable = true;
  marchcraft.services.yubikey.enable = true;
  marchcraft.services.easyroam.enable = true;
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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9YmsoGRK/KiU4zOV342MXdPV/EV7u7UyPHd9oMkSzFrKVSVclgKKo5RZRjSMHn4rvSPSOJlOodgSe+xvS46uSDE4WaF97kE2rCg71XXEPD5mbNY5fCqTtKBeYvePwNff4VfqQAXiNBl4Wt0dM07hrDai631l659LNHVa8/kZPtn//sDIJ31MlAxVW1MGfEbwIoMKlaAEQsVVVScQV7w22f1oQDBthkoHzHdEVFAr1NfQh2+Y6YOqS/eLrtnjI6UguU/jQHLkNxjlr5UXNmipoaHyNOdlJX24HgOK+XcTa9LqWFxSX24F24PO59NL0p83Ww9V6LR1oodqghEQrI9JItry5jQfd5cY5FfQh8cvEhURuHhguqNYzLIWyrOrWsTk4Im6+OtaACxxRxHbmofJNxCVlX4mEeENOVa7lGCqEsoL3mNOZ4JKCM7Xorr8/yMfcIIv2uLpa+HofRuUt+KK0EMRC1mqGbY79nOpvGAi/piV1S+A+0eLqtOnIr51myEf73I7yrO6ZHV9SixGQPYJuIx7bhDiKNEq+q0K3EugUq126s5bm7yRryRpeKv8HNvcKHUnwl7moAoBYr4PSeGp2z4S80fLO2IT2fJqxb/gSGu9FdA6TWyouqXlDsAK/XZ8Iw43F6r87f99rBvdJ/rJXozwS4VZ9u84H/YQv20Cy6Q=="
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCSzPwzWF8ETrEKZVrcldR5srYZB0debImh6qilNlH4va8jwVT835j4kTnwgDr/ODd5v0LagYiUVQqdC8gX/jQA9Ug9ju/NuPusyqro2g4w3r72zWFhIYlPWlJyxaP2sfUzUhnO0H2zFt/sEe8q7T+eDdHfKP+SIdeb9v9/oCAz0ZVUxCgkkK20hzhVHTXXMefjHq/zm69ygW+YpvWmvZ7liIDAaHL1/BzOtuMa3C8B5vP3FV5bh7MCSXyj5mIvPk7TG4e673fwaBYEB+2+B6traafSaSYlhHEm9H2CiRfEUa2NrBRHRv1fP4gM60350tUHLEJ8hM58LBymr3NfwxC00yODGfdaaWGxW4sxtlHw57Ev6uNvP2cN551NmdlRX7qKQKquyE4kUWHPDjJMKB8swj3F4/X6iAlGZIOW3ivcf+9fE+FUFA45MsbrijSWWnm/pOe2coP1KMvFNa6HMzCMImCAQPKpH5+LfT7eqfenDxgsJR5zm3LbrMJD6QhnBqPJsjH6gDzE17D5qctyMFy0DOad9+aVUWry1ymywSsjHuhMBcgQOgk3ZNdHIXQn5y6ejWaOJnWxZHFPKEeiwQK8LuE3cAj18p8r/rBnwhn7KHzlAgY0pgEZKrDSKIXDutFF9Y49hHyGpe3oI+oscBmH2xr0au/eNKlr/J85b9FdaQ== cardno:25_432_707"
  ];

  system.stateVersion = "23.11";
}
