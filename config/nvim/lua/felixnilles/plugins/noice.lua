return {
    -- {
    --     "folke/noice.nvim",
    --     event = "VeryLazy",
    --     opts = {
    --         lsp= {
    --             signature = {
    --                 enabled = false
    --             }
    --         },
    --         override = {
    --             ["vim.lsp.hover.enabled"] = false
    --         }
    --     },
    --     dependencies = {
    --         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --         "MunifTanjim/nui.nvim",
    --         -- OPTIONAL:
    --         --   `nvim-notify` is only needed, if you want to use the notification view.
    --         --   If not available, we use `mini` as the fallback
    --         "rcarriga/nvim-notify",
    --     }
    -- }
    {
        "rcarriga/nvim-notify",
        lazy = true,
        config = function ()
            require("notify").setup({
                stages = "fade",
                timeout = 1000,
                background_colour = "#000000",
                icons = {
                    ERROR = "",
                    WARN = "",
                    INFO = "",
                    DEBUG = "",
                    TRACE = "✎",
                },
            })
        end
    }

}
