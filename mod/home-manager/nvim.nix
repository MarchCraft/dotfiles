{ lib
, config
, pkgs
, ...
}: {
  options.marchcraft.neovim.enable = lib.mkEnableOption "install the neovim config";

  config = lib.mkIf config.marchcraft.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = true;
    };

    home.packages = with pkgs; [
      # lsps
      alejandra
      beautysh
      black
      clang-tools
      clojure-lsp
      hadolint
      lua-language-server
      marksman
      nil
      nixd
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      prettierd
      pyright
      ruff
      rust-analyzer
      taplo
      texlab
      vscode-langservers-extracted
      zls
      vscode-extensions.vadimcn.vscode-lldb.adapter
      # other stuff
      cargo
      rustfmt
      clippy
      vale
      ripgrep
      lazygit
      nixpkgs-fmt
      gcc
      git # for lazy
      # for tex preview
      zathura
      texliveFull
      nodejs
    ];

    home.file = {
      ".config/nvim" = {
        source = ../../config/nvim;
        recursive = true;
      };

      ".config/zathura/zathurarc".text = ''
        set render-loading false
      '';
    };
  };
}
