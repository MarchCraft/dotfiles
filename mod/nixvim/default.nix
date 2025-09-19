{ lib, outputs, ... }:
{
  imports = [
    ./nav.nix
    ./lsp.nix
    ./settings.nix
    ./git.nix
  ];

  autoCmd = [
    {
      command = "lua vim.lsp.buf.format()";
      event = [
        "BufWritePre"
      ];
      pattern = [ "*" ];
    }
  ];

  plugins.codesnap.enable = true;

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
          {
            name = "copilot";
          }
        ];
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
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
