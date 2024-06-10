{ config, lib, pkgs, ... }:

{
    imports =[
        ./hardware-configuration.nix
        ../share/desktop.nix
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes"];

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
    };
    boot.initrd.luks.devices = {
        root = {
            device = "/dev/disk/by-uuid/be3fa71f-caf0-436e-94b1-6f8f6c7c514b";
            preLVM = true;
        };
    };
    boot.plymouth.enable = true;
    boot.kernelParams = ["quiet" "splash"];

    networking.hostName = "Felix-Desktop";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Amsterdam";

    # Enable sound.
    sound.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [
        vesktop
        spotify
        catppuccin-plymouth
        tidal-hifi
    ];

    system.stateVersion = "master";

}

