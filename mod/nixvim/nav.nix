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
  ];

  plugins.yazi = {
    enable = true;
  };

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
