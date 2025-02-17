{ lib, outputs, ... }:
{
  imports = [
    ./nav.nix
    ./lsp.nix
    ./settings.nix
    ./git.nix
  ];

  plugins.lz-n.enable = true;
  plugins.cmp =
    let
      border = [
        "╭"
        "─"
        "╮"
        "│"
        "╯"
        "─"
        "╰"
        "│"
      ];
    in
    {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          {
            name = "nvim_lsp";
          }
          {
            name = "luasnip";
          }
          {
            name = "path";
          }
          {
            name = "buffer";
          }
        ];
        window.completion.border = border;
        window.documentation.border = border;
      };
    };

  plugins.copilot-cmp = {
    enable = true;
    event = [
      "InsertEnter"
      "LspAttach"
    ];
  };

  plugins.nui.enable = true;

  plugins.cmp-treesitter.enable = true;
  plugins.treesitter = {
    enable = true;
    settings = {
      auto_install = true;
      highlight.enable = true;
    };
  };

  globals = {
    mapleader = " ";
  };

  colorschemes.catppuccin.enable = true;
}
