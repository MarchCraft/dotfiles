{
  pkgs,
  pkgs-stable,
  outputs,
  config,
  ...
}:
{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nixos-wallpaper-catppuccin-mocha.png?raw=true";
    sha256 = "sha256-fmKFYw2gYAYFjOv4lr8IkXPtZfE1+88yKQ4vjEcax1s=";
  };
  stylix.polarity = "dark";

  hardware.steam-hardware.enable = true;
  programs.wireshark.enable = true;

  stylix.targets.fish.enable = false;

  virtualisation.docker.enable = true;

  environment.systemPackages = [
    outputs.packages."${pkgs.stdenv.system}".nixvim
    pkgs.tailscale
    pkgs-stable.thunderbird
    pkgs.moonlight-qt
    pkgs.brave
    pkgs.tidal
    pkgs.easyeffects
    pkgs.element-desktop
    pkgs.rpi-imager
    pkgs.remmina
    pkgs.spot
    pkgs.rbw
    pkgs.rofi-rbw
    pkgs.ldns
    pkgs.busybox
    pkgs.libreoffice-qt
    pkgs.wasistlos
    pkgs.signal-desktop
  ];

  programs.java.enable = true;

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "felix" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  users.users.felix.extraGroups = [
    "docker"
    "wpa_supplicant"
  ];
  virtualisation.docker.storageDriver = "btrfs";

  stylix = {
    fonts = {
      monospace = {
        package = pkgs.monocraft;
        name = "Monocraft Nerd Font Complete";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sizes = {
        terminal = 9;
      };
    };

    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 24;
    };

    opacity.terminal = 0.94;
  };

  marchcraft.greeter = {
    enable = true;
    defaultUser = "felix";
    command = "river";
  };

  sops.secrets.nextcloud = {
    owner = "felix";
    path = "/home/felix/.netrc";
    sopsFile = ../secrets/nextcloud;
    format = "binary";
  };

  services.tailscale.enable = true;

  sops.secrets.openvpn_config = {
    sopsFile = ../secrets/openvpn_config;
    format = "binary";
  };

  sops.secrets.openvpn-credentials = {
    sopsFile = ../secrets/openvpn_credentials;
    format = "binary";
  };

  services.openvpn.servers = {
    uniVPN = {
      config = ''config ${config.sops.secrets.openvpn_config.path}'';
    };
  };
}
