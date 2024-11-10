return {
    {
        "numToStr/FTerm.nvim",
        lazy = true,
        keys = {
            { "<A-t>", '<cmd>lua require("FTerm").toggle()<CR>' },
            { "<A-t>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', mode = { "t" } }
        },
        opts = {
            border = 'rounded'
        }
    },
    "svermeulen/vim-cutlass",
    {
        "tpope/vim-commentary",
        keys = { { "gc", nil, mode = { "n", "x", "o" } } }
    },
    {
        'fedepujol/move.nvim',
        config = function()
            require('move').setup({})
            local opts = { noremap = true, silent = true }
            vim.keymap.set('v', '<S-j>', ':MoveBlock(1)<CR>', opts)
            vim.keymap.set('v', '<S-k>', ':MoveBlock(-1)<CR>', opts)
        end
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/vaults/personal",
                },
                {
                    name = "uni",
                    path = "~/vaults/uni",
                },
            },
        },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                search = {
                    enabled = true,
                },
            },
        },
        keys = {
            { "<c-f>", mode = { "n", "x", "o" }, function() require("flash").jump() end },
        },
    },
    {
        "christoomey/vim-tmux-navigator",
        keys = {
            { "<A-l>", "<cmd>TmuxNavigateRight<CR>" },
            { "<A-h>", "<cmd>TmuxNavigateLeft<CR>" },
            { "<A-j>", "<cmd>TmuxNavigateDown<CR>" },
            { "<A-k>", "<cmd>TmuxNavigateUp<CR>" },
            { "<A-,>", "<cmd>TmuxNavigatePrevious<CR>" },
        },
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
            vim.g.tmux_navigator_save_on_switch = 2
        end,
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {}
    },
}
