{ pkgs
, ...
}: {
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

  programs.kdeconnect.enable = true;
  services.usbmuxd.enable = true;
  services.tailscale.enable = true;
}
