{ config, lib, pkgs, stylix, ... }:

{
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes"];

    imports = [
        ./hardware-configuration.nix
        ../share/desktop.nix
        # ../share/wireguard.nix
        ../share/term.nix
        ../share/matrix.nix
    ];

    boot.loader.systemd-boot.enable = false;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelParams = [ "apple_dcp.show_notch=1" "quiet"];
    boot.supportedFilesystems = [ "ntfs" ];


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

    boot.plymouth.enable = true;
    stylix.autoEnable = false;
    stylix.image = pkgs.fetchurl {
        url = "https://pbs.twimg.com/media/EDyxVvoXsAAE9Zg.png";
        sha256 = "sha256-NRfish27NVTJtJ7+eEWPOhUBe8vGtuTw+Osj5AVgOmM=";
    };

    environment.persistence."/persist/system" = {
        hideMounts = true;
        files = [
            "/etc/machine-id"
            "/etc/ssh/ssh_host_ed25519_key.pub"
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_rsa_key" 
            "/etc/ssh/ssh_host_rsa_key.pub"
            "/var/cache/regreet/cache.toml"
        ];
    };

    programs.fuse.userAllowOther = true;

    stylix.targets.plymouth.enable = true;

    virtualisation.docker.enable = true;

    users.defaultUserShell = pkgs.fish;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    console.keyMap = "de";

    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

    services.printing.enable = true;

    networking.hostName = "MacBook-Pro";

    time.timeZone = "Europe/Berlin";

    environment.systemPackages = with pkgs; [
        armcord
        spotify-qt
        spotifyd
        catppuccin-plymouth
        zapzap
    ];
    hardware.asahi.peripheralFirmwareDirectory = ./firmware;

    system.stateVersion = "23.10"; # Did you read the comment?

}

