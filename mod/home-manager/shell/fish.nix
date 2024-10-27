{ config
, pkgs
, lib
, ...
}: {
  options.marchcraft.shell.fish.enable = lib.mkEnableOption "install the fish config";

  config = lib.mkIf config.marchcraft.shell.fish.enable {
    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fastfetch = {
      enable = true;
      settings = lib.importJSON ./fastfetch.json;
    };

    home.packages = with pkgs.fishPlugins;
      [
        autopair
        colored-man-pages
        puffer
        sponge
        foreign-env
        grc
      ]
      ++ [
        pkgs.grc
        pkgs.fastfetch
      ];

    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        set fish_greeting
        fastfetch
        bind \cf "fd --full-path ~/dev/ -d 3 | fzf | xargs vi"
      '';

    };
  };
}
