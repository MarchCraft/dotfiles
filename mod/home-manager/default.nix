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
  gtk.iconTheme.name = "Papirus-Dark-Maia"; # Candy and Tela also look good
  gtk.iconTheme.package = pkgs.papirus-maia-icon-theme;

  home.sessionVariables = {
    GTK_THEME = "Dracula";
  };
}
