{ lib
, config
, ...
}: {
  options.marchcraft.services.wifi = {
    enable = lib.mkEnableOption "enable wifi services configuration";

    secretsFile = lib.mkOption {
      type = lib.types.path;
      description = "path to the sops secret file used for passwords";
    };

    networks = lib.mkOption {
      type = lib.types.nonEmptyListOf lib.types.nonEmptyStr;
      description = "network ssids to configure";
    };
  };

  config =
    let
      opts = config.marchcraft.services.wifi;
    in
    lib.mkIf opts.enable {
      sops.secrets.wifi = {
        sopsFile = opts.secretsFile;
        format = "binary";
      };

      networking.wireless = {
        enable = true;
        userControlled.enable = true;
        environmentFile = /run/secrets/wifi;

        networks =
          let
            passwordEnvName = name:
              (lib.strings.toUpper
                (builtins.replaceStrings [ " " "-" ] [ "_" "_" ]
                  name))
              + "_PASSWORD";
          in
          lib.attrsets.genAttrs opts.networks (ssid: {
            psk = "@${passwordEnvName ssid}@";
          });

      };
    };
}
