{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];


  home-manager.users.felix = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "18.09";
    home.username = "felix";
    home.homeDirectory = "/home/felix";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
	imports = [
	  ./waybar.nix
	];
        programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.neovim.withPython3 = true;
  programs.neovim.viAlias = true;
  home.packages = [
    pkgs.noto-fonts
    pkgs.noto-fonts-emoji
    (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = [pkgs.rofi-calc];
  };
  programs.librewolf = {
    enable = true;
    # Enable WebGL, cookies and history
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
  };
  programs.home-manager.enable = true;
  home.file = {
    ".config/swaylock/config".source = ../../config/swaylock/config;
    ".config/kitty/kitty.conf".source = ../../config/kitty/kitty.conf;
    ".config/starship.toml".source = ../../config/starship.toml;
    ".config/nvim" = {
      source = ../../config/nvim;
      recursive = true;
    };
    ".config/rofi" = {
        source = ../../config/rofi;
        recursive = true;
    };
    ".config/fastfetch/config.jsonc".source = ../../config/fastfetch/config.jsonc;
    ".config/hypr" = {
        source = ../../config/hypr;
        recursive = true;
    };
    ".config/fish" = {
      source = ../../config/fish;
      recursive = true;
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.materia-theme;
    };
    iconTheme = {
        package = pkgs.gnome.adwaita-icon-theme;
        name = "adwaita-icon-theme";
    };

  };
  programs.git = {
    enable = true;
    userName  = "Felix Nilles";
    userEmail = "felix@dienilles.de";
  };
  };
}
