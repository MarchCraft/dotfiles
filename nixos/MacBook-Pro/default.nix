{
  inputs,
  outputs,
  config,
  lib,
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

  services.flatpak.enable = true;

  hardware.bluetooth.enable = true;

  hardware.openrazer.enable = true;

  hardware.openrazer.users = [ "felix" ];

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
      "c4" = { };
      "Felix Admin" = "FelixAdmin";
      "HHU" = {
        auth = ''
          eap=PEAP
          key_mgmt=WPA-EAP
          identity="mel05saq"
          password=ext:HHUPassword
          phase2="auth=MSCHAPV2"
        '';
      };
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

  marchcraft.services.wireguard = {
    enable = true;
    ip = "100.10.0.3";
    secretsFile = ../secrets/wireguard-client;
    secretsFile2 = ../secrets/wireguard-client2;
    secretsFile3 = ../secrets/wireguard-client3;
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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCSzPwzWF8ETrEKZVrcldR5srYZB0debImh6qilNlH4va8jwVT835j4kTnwgDr/ODd5v0LagYiUVQqdC8gX/jQA9Ug9ju/NuPusyqro2g4w3r72zWFhIYlPWlJyxaP2sfUzUhnO0H2zFt/sEe8q7T+eDdHfKP+SIdeb9v9/oCAz0ZVUxCgkkK20hzhVHTXXMefjHq/zm69ygW+YpvWmvZ7liIDAaHL1/BzOtuMa3C8B5vP3FV5bh7MCSXyj5mIvPk7TG4e673fwaBYEB+2+B6traafSaSYlhHEm9H2CiRfEUa2NrBRHRv1fP4gM60350tUHLEJ8hM58LBymr3NfwxC00yODGfdaaWGxW4sxtlHw57Ev6uNvP2cN551NmdlRX7qKQKquyE4kUWHPDjJMKB8swj3F4/X6iAlGZIOW3ivcf+9fE+FUFA45MsbrijSWWnm/pOe2coP1KMvFNa6HMzCMImCAQPKpH5+LfT7eqfenDxgsJR5zm3LbrMJD6QhnBqPJsjH6gDzE17D5qctyMFy0DOad9+aVUWry1ymywSsjHuhMBcgQOgk3ZNdHIXQn5y6ejWaOJnWxZHFPKEeiwQK8LuE3cAj18p8r/rBnwhn7KHzlAgY0pgEZKrDSKIXDutFF9Y49hHyGpe3oI+oscBmH2xr0au/eNKlr/J85b9FdaQ== cardno:25_432_707"
  ];

  # services.displayManager.sddm = {
  #   enable = true;
  #
  #   # Enables experimental Wayland support
  #   wayland.enable = true;
  # };
  #
  # services.xserver = {
  #   enable = true;
  #
  #   windowManager.i3 = {
  #     enable = true;
  #     extraPackages = with pkgs; [
  #       dmenu # application launcher most people use
  #       i3status # gives you the default i3 status bar
  #       i3lock # default i3 screen locker
  #     ];
  #   };
  # };

  # services.open-webui.enable = true;
  # services.ollama.enable = true;
  environment.systemPackages = with pkgs; [
    #tidal-hifi
    box64
  ];
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "castlabs-electron"
    ];

  system.stateVersion = "23.11";
}
