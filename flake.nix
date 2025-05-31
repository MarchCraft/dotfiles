{
  description = "MarchCraft's nixos config. ein satz mit x, das war wohl nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hm = {
      url = "github:nix-community/home-manager";
    };
    nur.url = "github:nix-community/NUR";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon-support.url = "github:nix-community/nixos-apple-silicon";
    impermanence.url = "github:nix-community/impermanence";
    betterfox.url = "github:HeitorAugustoLN/betterfox-nix";
    templates.url = "github:nixos/templates";
    nix-easyroam.url = "github:0x5a4/nix-easyroam";
    nixos-aarch64-widevine.url = "github:epetousis/nixos-aarch64-widevine";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi.url = "github:sxyazi/yazi";
    nixvim.url = "github:nix-community/nixvim";
    nixcord.url = "github:KaylorBen/nixcord";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-master,
      nixpkgs-stable,
      sops,
      nixvim,
      ...
    }@inputs:
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

      nixvimModuleFor = pkgs: {
        inherit pkgs;
        module = import ./mod/nixvim;
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
            pkgs-x86 = import nixpkgs-stable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [ ./nixos/${hostname} ];
        };
      };

      genSystems =
        hostnames:
        builtins.foldl' (
          acc: hostname:
          let
            system = hostnameToSystem.${hostname}; # Get system from mapping
          in
          lib.trivial.mergeAttrs acc (mkSystem hostname system)
        ) { } hostnames;

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
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      packages = forAllSystems (
        system:
        import ./pkgs nixpkgs.legacyPackages.${system}
        // {
          nixvim = nixvim.legacyPackages.${system}.makeNixvimWithModule (
            nixvimModuleFor nixpkgs.legacyPackages.${system}
          );
        }
      );
      overlays = import ./overlays.nix { inherit inputs; };

      nixosModules.marchcraft = import ./mod/nixos;
      homeManagerModules.marchcraft = import ./mod/home-manager;

      nixosConfigurations = genSystems [
        "MacBook-Pro"
        "Felix-Desktop"
      ];

      devShells = forAllSystems devShell;
    };
}
