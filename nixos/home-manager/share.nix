{ pkgs, ... }:

{
  stylix.iconTheme = {
    enable = true;
    package = pkgs.dracula-icon-theme;
    dark = "Dracula";
  };

  programs.zathura = {
    enable = true;
  };

  marchcraft.desktop.hyprland = {
    enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "text/plain" = "neovim.desktop";
      "application/pdf" = "zathura.desktop";
    };
  };

  systemd.user = {
    services.nextcloud-autosync = {
      Unit = {
        Description = "Auto sync Nextcloud";
        After = "network-online.target";
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.nextcloud-client}/bin/nextcloudcmd -h -n --path /Documents /home/felix/Documents https://nextcloud.marchcraft.de";
        TimeoutStopSec = "180";
        KillMode = "process";
        KillSignal = "SIGINT";
      };
      Install.WantedBy = [ "multi-user.target" ];
    };
    timers.nextcloud-autosync = {
      Unit.Description = "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 60 minutes";
      Timer.OnBootSec = "5min";
      Timer.OnUnitActiveSec = "60min";
      Install.WantedBy = [
        "multi-user.target"
        "timers.target"
      ];
    };
    startServices = true;
  };
}
