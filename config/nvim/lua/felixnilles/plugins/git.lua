return {
    {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('gitsigns').setup()
        end,
        event = "User GitFile",
        cmd = { "Gitsigns" },
        keys = {
        --     { "<leader>og",  "<cmd>Gitsigns toggle_linehl<CR>" },
        --     { "<leader>gb",  "<cmd>Gitsigns toggle_current_line_blame<CR>" },
        --     { "<leader>gx",  "<cmd>Gitsigns toggle_deleted<CR>" },
        --     { "<leader>gd",  "<cmd>Gitsigns diffthis<CR>" },
        --     { "<leader>gn",  "<cmd>Gitsigns next_hunk<CR>" },
        --     { "<leader>gc",  "<cmd>Gitsigns prev_hunk<CR>" },
        --     { "<leader>g+",  "<cmd>Gitsigns stage_hunk<CR>" },
        --     { "<leader>gs",  "<cmd>Gitsigns stage_buffer<CR>" },
        --     { "<leader>g#",  "<cmd>Gitsigns undo_stage_hunk<CR>" },
        --     { "<leader>grr", "<cmd>Gitsigns reset_hunk<CR>" },
        }
    },
    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    'sindrets/diffview.nvim',
}
