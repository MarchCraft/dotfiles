{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.marchcraft.nixconfig = {
    enable = lib.mkOption {
      description = "auto configure nix";
      type = lib.type.bool;
      default = true;
    };
    allowUnfree = lib.mkEnableOption "allow unfree packages in both home manager and nixos";
    enableChannels = lib.mkEnableOption "enable channels";
    extraNixConfFile = lib.mkOption {
      description = "path to file to include in nix.conf";
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
  };

  config = let
    opts = config.marchcraft.nixconfig;
  in {
    nixpkgs = {
      overlays = [
        outputs.overlays.additions
        outputs.overlays.stable
        outputs.overlays.master
        inputs.nur.overlays.default
      ];
      config.allowUnfree = opts.allowUnfree;
    };

    nix = let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      settings = {
        experimental-features = "nix-command flakes";
        flake-registry = "";
        nix-path = config.nix.nixPath;
        substituters = ["https://attic.hhu-fscs.de/fscs-public"];
        trusted-public-keys = ["fscs-public:MuWSWnGgABFBwdeum/8n4rJxDpzYqhgd/Vm7u3fGMig="];
      };
      channel.enable = opts.enableChannels;

      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      extraOptions =
        lib.optionalString
        (opts.extraNixConfFile != null)
        "!include ${opts.extraNixConfFile}";
    };

    programs.nh.enable = true;
    programs.command-not-found.enable = false;
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    environment.systemPackages = with pkgs; [
      comma
      hydra-check
      nix-output-monitor
      nixpkgs-review
    ];
  };
}
