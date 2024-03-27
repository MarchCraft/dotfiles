{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [
      ./hardware-configuration.nix
      ../share/desktop.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelParams = [ "apple_dcp.show_notch=1" ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Berlin";

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;
  
  system.stateVersion = "22.05"; # Did you read the comment?

}

