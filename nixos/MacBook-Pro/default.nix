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

  sops.secrets.felix_pwd = {
    format = "binary";
    sopsFile = ../secrets/felix_pwd;
    neededForUsers = true;
  };

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

  networking.hostName = "MacBook-Pro";

  users.defaultUserShell = pkgs.fish;

  programs.fish.enable = true;

  environment.shellAliases = {
    ls = null;
    ll = null;
    l = null;
  };

  system.stateVersion = "23.11";
}
