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
  boot.initrd.luks.yubikeySupport = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  boot.initrd.luks.devices = {
    "nixos-enc" = {
      device = "/dev/nvme0n1p6";
      preLVM = true;
      yubikey = {
        slot = 2;
        twoFactor = true;
        storage = {
          device = "/dev/nvme0n1p4";
        };
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ed4921ac-6b56-4654-86fb-1c88b200f37f";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/ed4921ac-6b56-4654-86fb-1c88b200f37f";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/ed4921ac-6b56-4654-86fb-1c88b200f37f";
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
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
  };

  hardware.graphics = {
    enable = true;
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
