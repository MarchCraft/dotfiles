{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [
      ./hardware-configuration.nix
      ../share/desktop.nix
    ];

  boot.loader.systemd-boot.enable = false;
  #boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelParams = [ "apple_dcp.show_notch=1" ];
  
  boot.loader.grub = {
   enable = true;
   device = "nodev";
   efiSupport = true;
   enableCryptodisk = true;
  };
  boot.initrd.luks.devices = {
   root = {
     device = "/dev/disk/by-uuid/2be34d45-78d1-4e69-bd35-c17a0f9f0524";
     preLVM = true;
   };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Berlin";

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;
  
  system.stateVersion = "22.05"; # Did you read the comment?

}

