{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./starship.nix
    ./fish.nix
    ./tmux.nix
    ./direnv.nix
  ];

  options.marchcraft.shell = {
    enableAliases = lib.mkEnableOption "enable 0x5a4s shell aliases";
    installTools = lib.mkEnableOption "enable misc command line tools";
    saneEnv = lib.mkOption {
      description = "set up sane environment variables";
      type = lib.types.bool;
      default = true;
    };
  };

  config = {
    home.sessionVariables = lib.mkIf config.marchcraft.shell.saneEnv {
      GOPATH = config.home.homeDirectory + "/.go";
    };

    xdg.enable = config.marchcraft.shell.saneEnv;

    home.packages =
      lib.mkIf config.marchcraft.shell.enableAliases (
        with pkgs;
        [
          bat
          duf
          eza
          fastfetch
          hyfetch
        ]
      )
      // lib.mkIf config.marchcraft.shell.installTools (
        with pkgs;
        [
          acpi
          bat
          duf
          eza
          fastfetch
          fd
          file
          jq
          man-pages-posix
          mdcat
          psmisc
          ripgrep
          speedtest-rs
          unzip
          wget
          xxd
        ]
      );

    home.shellAliases = lib.mkIf config.marchcraft.shell.enableAliases rec {
      # ls stuff
      ls = "eza -F --sort extension -n --no-user --group-directories-first --git --icons -Mo --hyperlink --git-repos-no-status --color-scale=size ";
      ll = ls + "-l ";
      la = ll + "-a ";
      l = ll;
      gls = ll + " --git-ignore ";
      # tree fake
      tree = ls + "--tree ";
      ltree = ll + "--tree ";
      gtree = ltree + "--gitignore ";
      tr33 = tree + "--level=3 ";
      tr22 = tree + "--level=2 ";
      # convenience
      cat = "bat";
      ccat = "command cat";
      lsblk = "command lsblk -f";
      mkdirp = "mkdir -p";
      rm = "rm -Iv";
      df = "duf";
      # fun
      hyfetch = "hyfetch -b fastfetch";
      neofetch = hyfetch;
      # git
      gs = "git status -sb";
      gd = "git diff";
      gdc = "git diff --cached";
      ga = "git add";
      gaa = "git add --all";
      gl = "git lg";
      gcm = "git commit -m";
      y = "yazi";
    };
  };
}
