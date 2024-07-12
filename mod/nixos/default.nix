{...}: {
  imports = [
    ./services
    ./desktop
    ./misc
    ./users.nix
    ./nixconfig.nix
    ./bootconfig.nix
    ./impermanence.nix
    ./audio.nix
  ];
}
