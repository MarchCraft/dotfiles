{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.misc.enable = lib.mkEnableOption "install misc";
  config = lib.mkIf config.marchcraft.misc.enable {
    environment.systemPackages = with pkgs; [
      armcord
      zapzap
      tidal-hifi
      chromium
      rustup
      prismlauncher
      spotifyd
      spotify-qt
      spot
      wayvnc
      wdisplays
      wl-mirror
      wlsunset
    ];

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
