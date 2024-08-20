{ pkgs, ... }: {
  imports = [
    ./desktop
    ./shell
    ./btop.nix
    ./git.nix
    ./impermanence.nix
    ./nvim.nix
    ./yazi.nix
  ];
  gtk = {
    enable = true;
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
  };
}
