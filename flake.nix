{
  description = "MarchCraft's nixos config. ein satz mit x, das war wohl nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/?rev=a32f745778c5ae72a07213503f9889ec7641939f";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hm = {
      url = "github:0x5a4/home-manager/init-wayfire";
    };
    nur.url = "github:nix-community/NUR";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";
    impermanence.url = "github:nix-community/impermanence";
    betterfox.url = "github:HeitorAugustoLN/betterfox-nix";
    templates.url = "github:nixos/templates";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , impermanence
    , nixpkgs-master
    , nixpkgs-stable
    , sops
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      lib = nixpkgs.lib;

      forAllSystems = lib.genAttrs systems;

      hostnameToSystem = {
        "MacBook-Pro" = "aarch64-linux"; # or "aarch64-darwin" if applicable
        "Felix-Desktop" = "x86_64-linux"; # specify the correct architecture
      };

      mkSystem = hostname: system: {
        "${hostname}" = lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            pkgs-master = import nixpkgs-master {
              system = system; # Now dynamic
              config.allowUnfree = true;
            };
            pkgs-stable = import nixpkgs-stable {
              system = system; # Also dynamic
              config.allowUnfree = true;
            };
          };
          modules = [ ./nixos/${hostname} ];
        };
      };

      genSystems = hostnames:
        builtins.foldl'
          (acc: hostname:
            let system = hostnameToSystem.${hostname}; # Get system from mapping
            in lib.trivial.mergeAttrs acc (mkSystem hostname system)
          )
          { }
          hostnames;

      devShell =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default =
            with pkgs;
            mkShell {
              sopsPGPKeyDirs = [
                "${toString ./.}/nixos/keys/hosts"
                "${toString ./.}/nixos/keys/users"
              ];

              nativeBuildInputs = [
                (pkgs.callPackage sops { }).sops-import-keys-hook
              ];
            };
        };

    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays.nix { inherit inputs; };

      nixosModules.marchcraft = import ./mod/nixos;
      homeManagerModules.marchcraft = import ./mod/home-manager;

      nixosConfigurations = genSystems [ "MacBook-Pro" "Felix-Desktop" ];

      devShells = forAllSystems devShell;
    };
}
