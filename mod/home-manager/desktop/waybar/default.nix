{
  config,
  lib,
  pkgs,
  ...
}:

let
  sharedModules = builtins.fromJSON (builtins.readFile ../../../../config/waybar/config.json);
in
{
  options.marchcraft.waybar.enable = lib.mkEnableOption "install waybar";

  config = lib.mkIf config.marchcraft.waybar.enable {

    home.packages = with pkgs; [
      (python312.withPackages (p: [ p.requests ]))
      pamixer
      brightnessctl
      wl-mirror
      khal
    ];

    home.file = {
      ".config/waybar/style.css".source = ../../../../config/waybar/style.css;
      ".config/waybar/scripts".source = ../../../../config/waybar/scripts;
    };

    # ----------------------------
    # VDIRSYNCER
    # ----------------------------
    services.vdirsyncer.enable = true;

    sops.gnupg.home = "/home/felix/.gnupg";

    sops.secrets.caldav_username = {
      sopsFile = ../../../../nixos/secrets/vdirsyncer.yml;
    };

    sops.secrets.caldav_password = {
      sopsFile = ../../../../nixos/secrets/vdirsyncer.yml;
    };

    sops.templates.vdirsyncer-config = {
      path = "/home/felix/.config/vdirsyncer/config";

      content = ''
        [general]
        status_path = "/home/felix/.local/state/vdirsyncer/status/"

        [pair my_calendar]
        a = "my_calendar_local"
        b = "my_calendar_remote"
        collections = ["from a", "from b"]

        [storage my_calendar_local]
        type = "filesystem"
        path = "~/.calendars/my_calendar/"
        fileext = ".ics"

        [storage my_calendar_remote]
        type = "caldav"
        url = "https://nextcloud.marchcraft.de/remote.php/dav/"
        username = "${config.sops.placeholder.caldav_username}"
        password = "${config.sops.placeholder.caldav_password}"
      '';
    };

    xdg.configFile."khal/config".text = ''
      [calendars]

      [[my_calendar]]
      path = ~/.calendars/my_calendar/
      type = calendar

      [default]
      default_calendar = my_calendar
      timedelta = 5d

      [locale]
      dateformat = %x
      datetimeformat = %c
      timeformat = %H:%M
      firstweekday = 0
      unicode_symbols = True
      weeknumbers = off

      [view]
      agenda_event_format = {calendar-color}{cancelled}{start-end-time-style} {title}{repeat-symbol}{reset}
    '';

    # ----------------------------
    # WAYBAR
    # ----------------------------
    stylix.targets.waybar.enable = false;

    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          mod = "dock";
          margin-top = 4;
          margin-bottom = 4;

          modules-left = [
            "clock"
            "custom/weather"
            "custom/agenda"
            "network"
          ];

          modules-right = [
            "tray"
            "cpu"
            "memory"
            "battery"
            "pulseaudio"
          ];
        }
        // sharedModules;
      };
    };
  };
}
