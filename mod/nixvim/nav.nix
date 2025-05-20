{ lib, outputs, ... }:
{
  keymaps = [
    {
      action = "<cmd>Yazi<CR>";
      key = "<leader>fv";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope lsp_definitions<CR>";
      key = "<leader>gd";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>lua vim.lsp.buf.hover()<CR>";
      key = "<leader>ha";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
      key = "<leader>ca";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>lua require(\"lsp_lines\").toggle()<CR>";
      key = "<leader>ol";
      options = {
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope diagnostics<CR>";
      key = "<leader>di";
      options = {
        silent = true;
      };
    }
  ];

  plugins.yazi = {
    enable = true;
  };

  plugins.lsp-lines.enable = true;

  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>ff" = {
        action = "git_files";
        options = {
          desc = "Telescope Git Files";
        };
      };
      "<leader>fs" = "live_grep";
    };
  };

  plugins.tmux-navigator = {
    enable = true;
    keymaps = [
      {
        action = "left";
        key = "<A-h>";
      }
      {
        action = "down";
        key = "<A-j>";
      }
      {
        action = "up";
        key = "<A-k>";
      }
      {
        action = "right";
        key = "<A-l>";
      }
      {
        action = "previous";
        key = "<A-,>";
      }
    ];
  };

}
