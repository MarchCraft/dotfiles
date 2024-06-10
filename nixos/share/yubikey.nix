{ config, lib, pkgs, ... }:

{
    services.udev.packages = [ pkgs.yubikey-personalization ];

    security.pam.yubico = {
        enable = true;
        debug = true;
        mode = "challenge-response";
        id = [ "25432707" ];
        control = "required";
    };

}
