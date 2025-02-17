{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./greeter.nix
    ./swaylock.nix
    ./sunshine.nix
    ./cinny.nix
  ];

  programs.sway.enable = true;
}
