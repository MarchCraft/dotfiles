{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.marchcraft.bootconfig = {
    enable = lib.mkEnableOption "auto configure the boot loader";
  };

  config =
    let
      opts = config.marchcraft.bootconfig;
    in
    lib.mkIf opts.enable {
      boot.loader.systemd-boot.enable = false;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelParams = [
        "apple_dcp.show_notch=1"
        "quiet"
        "loglevel=3"
        "udev.log-priority=3"
      ];

      boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        theme = lib.mkForce pkgs.catppuccin-grub;
      };
    };
}
