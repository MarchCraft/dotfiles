return {
    "nvim-lua/plenary.nvim",
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        config = function()
            require("catppuccin").setup({

                flavour = "mocha", -- latte, frappe, macchiato, mocha
                background = {     -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false, -- disables setting the background color.
                show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
                term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
                dim_inactive = {
                    enabled = false,            -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15,          -- percentage of the shade to apply to the inactive window
                },
                no_italic = false,              -- Force no italic
                no_bold = false,                -- Force no bold
                no_underline = false,           -- Force no underline
                styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
                    comments = { "italic" },    -- Change the style of comments
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                color_overrides = {},
                custom_highlights = {},
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    notify = true,
                    mini = {
                        enabled = true,
                        indentscope_color = "",
                    },
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },

            })
            vim.cmd([[colorscheme catppuccin]])
        end,
    },
    {
        'nvim-tree/nvim-web-devicons',
        dependencies = {
            'prichrd/netrw.nvim'
        },
        event = "VeryLazy",
        config = function()
            require 'nvim-web-devicons'.get_icons()
            require 'netrw'.setup {
                -- Put your configuration here, or leave the object empty to take the default
                -- configuration.
                use_devicons = true, -- Uses nvim-web-devicons if true, otherwise use the file icon specified above
                mappings = {},       -- Custom key mappings
            }
        end
    },
    {
        "chrisgrieser/nvim-recorder",
        dependencies = "rcarriga/nvim-notify",
        lazy = false,
        opts = {},
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "User File",
        dependencies = "chrisgrieser/nvim-recorder",
        opts = {
            sections = {
                lualine_a = { 'mode' },
                lualine_b = {
                    'branch',
                    'diff',
                    {
                        'diagnostics',
                        sources = { 'nvim_lsp' },
                        sections = { 'error', 'warn', 'info' },
                    }
                },
                lualine_c = { "filename" },
                lualine_x = {
                    'encoding',
                    'fileformat',
                    'filetype'
                },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            options = {
                globalstatus = true,
                theme = 'catppuccin'
            }
        },
    },
    {
        "h-hg/numbers.nvim",
        config = true
    },
    {
        "rcarriga/nvim-notify",
        lazy = false,
        config = function()
            require("notify").setup({
                stages = "slide",
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
            vim.notify = require("notify")
        end
    }
}
