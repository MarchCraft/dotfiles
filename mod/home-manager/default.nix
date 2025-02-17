{ pkgs, ... }:
{
  imports = [
    ./desktop
    ./shell
    ./btop.nix
    ./git.nix
    ./nvim.nix
    ./yazi.nix
  ];
}
