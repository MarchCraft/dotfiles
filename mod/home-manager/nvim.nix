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
      stable.vscode-extensions.vadimcn.vscode-lldb.adapter
      vscode-extensions.vscjava.vscode-java-debug
      vscode-extensions.vscjava.vscode-java-test
      jdt-language-server
      kotlin-language-server
      gdb
      # other stuff
      cargo
      rustfmt
      rustc
      clippy
      vale
      ripgrep
      lazygit
      nixpkgs-fmt
      gcc
      git # for lazy
      python312Packages.six
      # for tex preview
      zathura
      texliveFull
      nodejs
      yarn
      openjdk21
    ];

    home.sessionVariables = {
      JAVA_TEST = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/";
      JAVA_DEBUG = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/";
    };

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
