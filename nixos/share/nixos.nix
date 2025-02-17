{ pkgs, ... }:
{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://pbs.twimg.com/media/EDyxVvoXsAAE9Zg.png";
    sha256 = "sha256-NRfish27NVTJtJ7+eEWPOhUBe8vGtuTw+Osj5AVgOmM=";
  };
  stylix.polarity = "dark";

  hardware.steam-hardware.enable = true;

  environment.systemPackages = [
    pkgs.tailscale
    pkgs.element-desktop
    pkgs.thunderbird
    pkgs.moonlight-qt
    pkgs.brave
    pkgs.tidal-hifi
    pkgs.chromium
    pkgs.tidal
    pkgs.easyeffects
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
    };

    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
    };

    opacity.terminal = 0.94;
  };

  programs.kdeconnect.enable = true;
  services.usbmuxd.enable = true;
  services.tailscale.enable = true;
}
