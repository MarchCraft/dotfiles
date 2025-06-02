{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "usb_storage"
    "usbhid"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [
    "dm-snapshot"
    "vfat"
    "nls_cp437"
    "nls_iso8859-1"
    "usbhid"
  ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d8f1e6d9-d4c1-4425-a7ff-0b3ab67ae595";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };
  boot.initrd.systemd.enable = true;

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/60516112-c25d-4801-b794-12f525f83057";

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/d8f1e6d9-d4c1-4425-a7ff-0b3ab67ae595";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/d8f1e6d9-d4c1-4425-a7ff-0b3ab67ae595";
    fsType = "btrfs";
    options = [ "subvol=persist" ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5748-1B07";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  hardware.asahi = {
    withRust = true;
    experimentalGPUInstallMode = "replace";
  };

  hardware.graphics = {
    enable = true;
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
