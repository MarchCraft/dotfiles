{ lib
, config
, inputs
, ...
}: {
  options.marchcraft.users =
    let
      t = lib.types;
      userOpts = t.submodule {
        options = {
          shell = lib.mkOption {
            description = "the users shell";
            type = t.shellPackage;
          };
          extraGroups = lib.mkOption {
            type = t.nullOr (t.listOf t.str);
          };
          hashedPasswordFile = lib.mkOption {
            type = t.nullOr (t.str);
          };
          home-manager = {
            enable = lib.mkEnableOption "enable home-manager for this user";
            config = lib.mkOption {
              description = "path to the users home.nix file";
              type = t.path;
            };
          };
        };
      };
    in
    lib.mkOption {
      type = t.attrsOf userOpts;
    };

  config =
    let
      opts = config.marchcraft.users;
    in
    {
      users.groups.users.gid = 100;
      users.users =
        lib.attrsets.mapAttrs
          (_: value: {
            uid = 1000;
            isNormalUser = true;
            shell = value.shell;
            hashedPasswordFile = value.hashedPasswordFile;
            extraGroups = value.extraGroups;
          })
          opts;

      home-manager =
        let
          want-hm =
            lib.attrsets.filterAttrs (_: value: value.home-manager.enable) opts;
        in
        {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs;
            pkgs-master = import inputs.nixpkgs-master {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          sharedModules = [
            inputs.sops.homeManagerModules.sops
          ];

          users =
            lib.attrsets.mapAttrs
              (
                name: value: { ... }: {
                  home.username = name;
                  home.homeDirectory = "/home/" + name;
                  imports = [ value.home-manager.config ];
                }
              )
              want-hm;
        };
    };
}
