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
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
	imports = [
	  ./waybar.nix
	];
        programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  useGlobalPkgs = true;
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
    theme = ../../config/rofi/config.rasi;
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





  };
}
