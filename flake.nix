{
  description = "MarchCraft's nixos config. ein satz mit x, das war wohl nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , impermanence
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

      mkSystem = hostname: {
        "${hostname}" = lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/${hostname} ];
        };
      };

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

      genSystems = hostnames:
        builtins.foldl' lib.trivial.mergeAttrs { } (builtins.map mkSystem hostnames);
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays.nix { inherit inputs; };

      nixosModules.marchcraft = import ./mod/nixos;
      homeManagerModules.marchcraft = import ./mod/home-manager;

      nixosConfigurations = genSystems [ "MacBook-Pro" ];

      devShells = forAllSystems devShell;
    };
}
