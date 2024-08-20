{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.misc.enable = lib.mkEnableOption "install misc";
  config = lib.mkIf config.marchcraft.misc.enable {
    home.packages = with pkgs; [
      wayvnc
    ];

    home.file = {
      ".config/wayvnc/config".text = ''
        use_relative_paths=true
        address=::
        enable_auth=true
        enable_pam=true
      '';
    };

  };
}
