{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        home-manager.url = github:nix-community/home-manager;
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = inputs @ { self, nixpkgs, home-manager, flake-utils }: {
            nixosConfigurations.macbook = nixpkgs.lib.nixosSystem {
                system = "aarch64-linux";
                modules =
                    [
                    ./nixos/macbook
                    <apple-silicon-support/apple-silicon-support>
                    ];
            };
        };
}
