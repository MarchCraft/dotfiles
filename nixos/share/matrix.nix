{ pkgs, lib, config, ... }:
{
    environment.systemPackages = with pkgs; [
        iamb
        cinny-desktop
    ];
}

