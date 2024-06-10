{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
        home-manager.url = "github:nix-community/home-manager";
        flake-utils.url = "github:numtide/flake-utils";
        stylix = {
            url = "github:danth/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        sops-nix.url = "github:Mic92/sops-nix";
        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
        apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";
        impermanence.url = "github:nix-community/impermanence";
    };

    outputs = inputs @ { self, nixpkgs, apple-silicon-support, nixpkgs-stable, home-manager, flake-utils, stylix, sops-nix, firefox-addons, impermanence}: 
        let
            system = "aarch64-linux";
            overlay-stable = final: prev: {
                stable = import nixpkgs-stable {
                    inherit system;
                    config.allowUnfree = true;
                };
            };
        in {
        nixosConfigurations.MacBook-Pro = nixpkgs.lib.nixosSystem {
            modules =
                [
                    ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
                    ./nixos/macbook
                    apple-silicon-support.nixosModules.apple-silicon-support
                    stylix.nixosModules.stylix
                    sops-nix.nixosModules.sops
                    impermanence.nixosModules.impermanence
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.felix = import ./nixos/home-manager/home.nix;
                        home-manager.extraSpecialArgs = {inherit inputs;};
                    }
                ];
        };
        nixosConfigurations.mainPc = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules =
                [
                    ./nixos/mainPc
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.felix = import ./nixos/home-manager/home.nix;
                        home-manager.extraSpecialArgs = {inherit inputs;};
                    }
                ];
        };
        devShells."aarch64-linux".default = with import nixpkgs {system = "aarch64-linux";};
        mkShell {
            sopsPGPKeyDirs = [
                "${toString ./.}/keys/hosts"
                "${toString ./.}/keys/users"
            ];

            nativeBuildInputs = [
                (pkgs.callPackage sops-nix {}).sops-import-keys-hook
            ];
        };
    };

}
