{ pkgs, ... }:
{
  imports = [
    ./desktop
    ./shell
    ./btop.nix
    ./git.nix
    ./yazi.nix
  ];
}
