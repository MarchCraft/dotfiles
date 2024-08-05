{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.misc.enable = lib.mkEnableOption "install misc";
  config = lib.mkIf config.marchcraft.misc.enable {
    environment.systemPackages = with pkgs; [
      armcord
      # zapzap
      # tidal-hifi
      # chromium
      rustup
    ];
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
