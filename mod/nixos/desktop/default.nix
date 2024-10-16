{ inputs, pkgs, ... }: {
  imports = [
    ./greeter.nix
    ./swaylock.nix
    ./sunshine.nix
  ];

  programs.sway.enable = true;
}
