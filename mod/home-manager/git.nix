{ config
, lib
, pkgs
, ...
}: {
  options.marchcraft.git.enable = lib.mkEnableOption "install the git config";

  config = lib.mkIf config.marchcraft.git.enable {
    home.packages = [
      pkgs.git-absorb
    ];

    programs.git = {
      enable = true;

      userName = "MarchCraft";
      userEmail = "30194994+MarchCraft@users.noreply.github.com";


      signing = {
        key = "BF91E7F996966393DF5992FE15215F777DC602FC";
        signByDefault = true;
      };

      aliases = {
        exec = "!exec ";
        make = "!exec make ";
        whoops = "commit --amend --no-edit";
        fuckup = "reset --soft HEAD~1";
        root = "rev-parse --show-toplevel";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        fpush = "push --force-with-lease";
      };
    };

    programs.gh = {
      enable = true;
      extensions = with pkgs; [
        gh-markdown-preview
      ];
    };
  };
}
