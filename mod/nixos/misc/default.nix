{ config
, lib
, pkgs
, pkgs-master
, ...
}: {
  options.marchcraft.misc.enable = lib.mkEnableOption "install misc";
  config = lib.mkIf config.marchcraft.misc.enable {
    environment.systemPackages = [
      pkgs.armcord
      pkgs.zapzap
      pkgs.tidal-hifi
      pkgs.chromium
      pkgs.prismlauncher
      pkgs.spotifyd
      pkgs.spotify-qt
      pkgs.spot
      pkgs.wayvnc
      pkgs.wdisplays
      pkgs.wl-mirror
      pkgs.wlsunset
      pkgs.playerctl
      pkgs.parsec-bin
      pkgs.pkg-config
      pkgs.openssl
      pkgs-master.obsidian
    ];


    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };

    security.pam.services.wayvnc = {
      text = ''
        auth    required pam_unix.so nodelay deny=3 unlock_time=600
        account required pam_unix.so nodelay deny=3 unlock_time=600
      '';
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 5900 ];
    };

    services.pcscd.enable = true;

    programs.thunar.enable = true;
    programs.xfconf.enable = true;

    programs.thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];

    services.gvfs.enable = true; # Mount, trash, and other functionalities
  };
}
