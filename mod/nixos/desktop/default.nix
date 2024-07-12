{ ... }: {
  imports = [
    ./greeter.nix
    ./swaylock.nix
  ];

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
}
