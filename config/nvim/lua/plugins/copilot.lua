return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require('copilot').setup({
                filetypes = {
                    yaml = true,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = true,
                },
                copilot_node_command = 'node', -- Node.js version must be > 18.x
                server_opts_overrides = {},
            })
        end
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- Optional
            {
                "stevearc/dressing.nvim",    -- Optional: Improves the default Neovim UI
                opts = {},
            },
        },
        config = function()
            require("codecompanion").setup({
                strategies = {
                    chat = {
                        adapter = "copilot",
                    },
                    inline = {
                        adapter = "copilot",
                    },
                    agent = {
                        adapter = "copilot",
                    },
                },
                adapters = {
                    anthropic = function()
                        return require("codecompanion.adapters").extend("copilot", {
                            env = {
                                api_key = "cmd:op read op:///persist/home/copilot --no-newline"
                            },
                        })
                    end,
                },
            })
        end
    }
}
