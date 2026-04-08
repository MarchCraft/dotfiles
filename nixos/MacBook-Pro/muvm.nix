{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  pkgsx86_64 = import inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  initScript = pkgs.writeShellScript "muvm-env-init.sh" ''
    ln -snf ${pkgsx86_64.mesa} /run/opengl-driver
    ln -snf ${pkgsx86_64.pkgsi686Linux.mesa} /run/opengl-driver-32
    echo 1 > /proc/sys/kernel/print-fatal-signals
    echo enable-shm=no > /run/pulse.conf
  '';

  wrapArgs = lib.escapeShellArgs [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath (
      (with pkgs; [
        box64
        fex
        socat
        squashfsTools
        squashfuse
      ])
      ++ (with pkgsx86_64; [
        (bottles.override { removeWarningPopup = true; })
        steam-run
        vintagestory
        dotnetCorePackages.dotnet_8.sdk
      ])
    ))
    "--add-flag"
    "--execute-pre=${initScript}"
  ];

  envArgs = lib.escapeShellArgs [
    "--env=PULSE_CLIENTCONFIG=/run/pulse.conf"
    "--env=mesa_glthread=true"
    "--env=DOTNET_ROOT=${pkgsx86_64.dotnetCorePackages.dotnet_8.sdk}/share/dotnet"
    "--env=STRx86=${pkgsx86_64.strace}/bin/strace"
    "--env=LD_LIBRARY_PATH=${
      # For vintagestory
      lib.makeLibraryPath (
        with pkgsx86_64;
        [
          gtk2
          sqlite
          openal
          cairo
          libGLU
          SDL2
          freealut
          libglvnd
          pipewire
          libpulseaudio
          libx11
          libxi
          libxcursor
        ]
      )
    }"
  ];

  muvm-wrapped = pkgs.stdenv.mkDerivation {
    name = "muvm";
    dontUnpack = true;
    buildInputs = [ pkgs.makeBinaryWrapper ];
    installPhase = ''
      mkdir -p $out/bin $out/share/applications
      makeBinaryWrapper ${pkgs.muvm}/bin/muvm $out/bin/muvm ${wrapArgs}

      cp ${pkgs.writeShellScript "muvm-shell" ''
        if [ "$#" -eq 0 ]; then
          exec muvm ${envArgs} ${lib.getExe pkgs.fish} --no-config
        else
          exec muvm ${envArgs} ${lib.getExe pkgs.fish} --no-config --command "$@"
        fi
      ''} $out/bin/muvm-shell

      cp ${pkgs.writeShellScript "steam" ''
        exec muvm ${envArgs} ${lib.getExe pkgsx86_64.steam-run} steam "$@"
      ''} $out/bin/steam

      cp ${pkgsx86_64.steam-unwrapped}/share/applications/steam.desktop $out/share/applications/steam.desktop
      sed -i 's/Icon=steam/Icon=${
        lib.escape [ "/" ] "${../assets/steam.png}"
      }/g' $out/share/applications/steam.desktop
    '';
    meta = {
      mainProgram = "muvm";
    };
  };
in
{
  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ];
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [
    distrobox
    muvm-wrapped
  ];

  programs = {
    virt-manager.enable = true;
  };
}
