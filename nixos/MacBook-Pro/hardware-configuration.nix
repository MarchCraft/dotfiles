{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "sdhci_pci" ];
  boot.kernelModules = [ "apple_dcp.show_notch=1" ];
  boot.extraModulePackages = [ ];

  boot.loader.grub = {
    enableCryptodisk = true;
  };

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/2be34d45-78d1-4e69-bd35-c17a0f9f0524";
      preLVM = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1bd3bc98-9832-452c-b925-99cde6814ce6";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/1bd3bc98-9832-452c-b925-99cde6814ce6";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/1bd3bc98-9832-452c-b925-99cde6814ce6";
    fsType = "btrfs";
    options = [ "subvol=persist" ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FDED-B06B";
    fsType = "vfat";
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-label/nixos /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  hardware.asahi = {
    withRust = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
  };

  hardware.graphics = {
    enable = true;
  };

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
