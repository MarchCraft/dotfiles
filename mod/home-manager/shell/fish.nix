{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.marchcraft.shell.fish.enable = lib.mkEnableOption "install the fish config";

  config = lib.mkIf config.marchcraft.shell.fish.enable {
    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fastfetch = {
      enable = true;
    };

    home.packages =
      with pkgs.fishPlugins;
      [
        autopair
        colored-man-pages
        puffer
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
        bind \cf "fd . ~/dev/ -d 3 | sed \"s|/home/felix/dev/||g\" | fzf | xargs -I {} bash -c 'cd \"/home/felix/dev/{}\" && nvim .'"
      '';
    };
  };
}
