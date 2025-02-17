{ lib, outputs, ... }:
{
  keymaps = [
    {
      action = "<cmd>Oil<CR>";
      key = "<leader>fv";
      options = {
        silent = true;
      };
    }
  ];

  plugins.oil = {
    enable = true;
    settings.keymaps = {
      "-" = "actions.parent";
      "<C-c>" = "actions.close";
      "<C-h>" = "actions.select_split";
      "<C-l>" = "actions.refresh";
      "<C-p>" = "actions.preview";
      "<C-s>" = "actions.select_vsplit";
      "<C-t>" = "actions.select_tab";
      "<CR>" = "actions.select";
      _ = "actions.open_cwd";
      "`" = "actions.cd";
      "g." = "actions.toggle_hidden";
      "g?" = "actions.show_help";
      "g\\" = "actions.toggle_trash";
      gs = "actions.change_sort";
      gx = "actions.open_external";
      "~" = "actions.tcd";
    };
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
