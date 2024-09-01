return {
    {
        'mbbill/undotree'
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = { "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
    },
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
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },
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
    },
    {
        'mfussenegger/nvim-lint',
        config = function()
            require('lint').linters_by_ft = {
                markdown = { 'vale', },
                rust = { 'clippy', }
            }
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false,   -- This plugin is already lazy
        config = function()
            local bufnr = vim.api.nvim_get_current_buf()
            vim.cmd([[autocmd! BufWritePre,TextChanged,InsertLeave *.js Prettier]])
            vim.keymap.set(
                "n",
                "<leader>ca",
                function()
                    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
                    -- or vim.lsp.buf.codeAction() if you don't want grouping.
                end,
                { silent = true, buffer = bufnr }
            )
            vim.g.rustaceanvim = {
                -- Plugin configuration
                tools = {
                    hover_actions = {
                        auto_focus = true,
                    },
                },
                -- LSP configuration
                server = {
                    default_settings = {
                        ['rust-analyzer'] = {
                        },
                    },
                    ---@param project_root string Path to the project root
                    settings = function(project_root)
                        local ra = require('rustaceanvim.config.server')
                        return ra.load_rust_analyzer_settings(project_root, {
                            settings_file_pattern = 'rust-analyzer.json'
                        })
                    end,
                },
                -- DAP configuration
                dap = {
                },
            }
        end,
    },
    {
        "folke/trouble.nvim",
        event = "BufRead",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        'numToStr/Comment.nvim',
        opts = {
            padding = true,
            sticky = true,
            ignore = nil,
            opleader = {
                line = '<gc>',
            },
            mappings = {
                basic = false,
                extra = true,
            },
            post_hook = nil,
        },
        lazy = false,
        config = function()
            require('Comment').setup()
        end
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        config = function()
            local harpoon = require("harpoon")

            vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<C-ö>", function() harpoon:list():select(4) end)
        end
    },
    {
        "prettier/vim-prettier",
        pin = true,
        ft = "javascript",
        config = function()
            vim.cmd([[autocmd! BufWritePre,TextChanged,InsertLeave *.js PrettierAsync]])
        end,
    },
    {
        "letieu/harpoon-lualine",
        dependencies = {
            {
                "ThePrimeagen/harpoon",
                branch = "harpoon2",
            }
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "Rics-Dev/project-explorer.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            paths = { "~/dev/*" },        --custom path set by user
            newProjectPath = "~/dev/",    --custom path for new projects
            file_explorer = function(dir) --custom file explorer set by user
                require("oil").open(dir)
                require("bw").open(dir)
            end,
        },
        config = function(_, opts)
            require("project_explorer").setup(opts)
        end,
        keys = {
            { "<leader>fp", "<cmd>ProjectExplorer<cr>", desc = "Project Explorer" },
        },
        lazy = false,
    }
}
