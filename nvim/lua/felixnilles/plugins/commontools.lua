return {
    {
        'mbbill/undotree'
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },
    "tpope/vim-surround",
    "svermeulen/vim-cutlass",
    {
        "tpope/vim-commentary",
        keys = { { "gc", nil, mode = { "n", "x", "o" } } }
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        keys = {
            {
                "<leader>ol",
                function()
                    require("lsp_lines").toggle()
                end,
            },
        },
        config = function()
            require("lsp_lines").setup({})
            vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
        end,
    }
}

