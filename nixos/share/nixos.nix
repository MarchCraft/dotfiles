{ pkgs, outputs, ... }:
{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nixos-wallpaper-catppuccin-mocha.png?raw=true";
    sha256 = "sha256-fmKFYw2gYAYFjOv4lr8IkXPtZfE1+88yKQ4vjEcax1s=";
  };

  hardware.steam-hardware.enable = true;
  programs.wireshark.enable = true;

  environment.systemPackages = [
    outputs.packages."${pkgs.stdenv.system}".nixvim
    pkgs.tailscale
    pkgs.thunderbird
    pkgs.moonlight-qt
    pkgs.brave
    pkgs.chromium
    pkgs.tidal
    pkgs.easyeffects
    pkgs.nheko
    pkgs.chromium
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

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
    command = "Hyprland";
  };

  sops.secrets.nextcloud = {
    owner = "felix";
    path = "/home/felix/.netrc";
    sopsFile = ../secrets/nextcloud;
    format = "binary";
  };

  services.tailscale.enable = true;
}
