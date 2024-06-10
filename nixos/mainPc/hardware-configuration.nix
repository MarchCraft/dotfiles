{ config, lib, pkgs, modulesPath, ... }:

{
    nixpkgs.config.allowUnfree= true;
    imports =[ 
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
    { device = "/dev/disk/by-uuid/3755aabb-c154-45c4-9d2d-2438b73bbc44";
        fsType = "ext4";
    };

    fileSystems."/boot" =
    { 
        device = "/dev/disk/by-uuid/1D43-760F";
        fsType = "vfat";
    };

    swapDevices =[
        { device = "/dev/disk/by-uuid/5989f97c-864e-4980-b1b8-6de94dac6e4d"; }
    ];

    networking.useDHCP = lib.mkDefault true;
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
