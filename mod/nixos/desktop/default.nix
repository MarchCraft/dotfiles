{ inputs, pkgs, ... }: {
  imports = [
    ./greeter.nix
    ./swaylock.nix
  ];

  programs.sway.enable = true;
}
