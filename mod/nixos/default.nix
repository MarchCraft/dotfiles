{ ... }:
{
  imports = [
    ./services
    ./desktop
    ./misc
    ./users.nix
    ./nixconfig.nix
    ./bootconfig.nix
    ./audio.nix
    ./servermounts.nix
    ./backups.nix
  ];
}
