{
  lib,
  stdenvNoCC,
  writeShellApplication,
  symlinkJoin,
  makeDesktopItem,
  muvm,
  fex,
  xorg,
  libXScrnSaver,
  coreutils,
  gnugrep,
  bash,
  extraEnv ? {
    PULSE_LATENCY_MSEC = "30";
    SDL_AUDIODRIVER = "pulseaudio";
    FEX_X87REDUCEDPRECISION = "1";
  },
}:

let
  extraEnvExports = lib.concatStringsSep "\n        " (
    lib.mapAttrsToList (k: v: "export ${k}=${lib.escapeShellArg v}") extraEnv
  );

  ts6Dir = "$HOME/.local/share/teamspeak6";

  initScript = writeShellApplication {
    name = "ts6-init";
    runtimeInputs = [ coreutils ];
    text = ''
      # minimal FHS fixes (NOT full steam pressure-vessel nonsense)
      mkdir -p /run/fhs/usr/bin

      ln -sf ${bash}/bin/bash /run/fhs/usr/bin/bash
      ln -sf ${coreutils}/bin/env /run/fhs/usr/bin/env
    '';
  };

  launcher = writeShellApplication {
    name = "teamspeak6";

    runtimeInputs = [
      coreutils
      gnugrep
      libXScrnSaver
      xorg.libX11
      xorg.libXext
    ];

    text = ''
      set -e

      ts6Dir="$HOME/.local/share/teamspeak6"

      if [[ ! -f "$ts6Dir/ts3client" && ! -f "$ts6Dir/TeamSpeak" ]]; then
        echo "TeamSpeak 6 not found in $ts6Dir"
        exit 1
      fi

      if [[ -f "$ts6Dir/TeamSpeak" ]]; then
        bin="$ts6Dir/TeamSpeak"
      else
        bin="$ts6Dir/ts3client"
      fi

      exec ${lib.getExe muvm} \
        --gpu-mode=drm \
        --execute-pre ${lib.getExe initScript} \
        --interactive \
        -- \
        FEXBash -c "\
          export LC_ALL=C.UTF-8; \
          export LANG=C.UTF-8; \
          export PULSE_SERVER=unix:/run/user/\$(id -u)/pulse/native; \
          ${extraEnvExports}; \
          exec $bin"
    '';
  };

  desktopItem = makeDesktopItem {
    name = "teamspeak6";
    desktopName = "TeamSpeak 6 (Asahi)";
    exec = "teamspeak6";
    categories = [
      "Network"
      "Chat"
    ];
  };

in
symlinkJoin {
  name = "teamspeak6";
  paths = [
    launcher
    desktopItem
  ];
}
