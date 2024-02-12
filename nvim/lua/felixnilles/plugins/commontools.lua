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
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function ()
            vim.g.rustfmt_autosave = 1
        end
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        ft = { 'rust' },
        config = function ()
            local lsp_zero = require('lsp-zero')
            local rt = require("rustaceanvim")
            local mason_registry = require("mason-registry")
            local cfg = require('rustaceanvim.config')


            local codelldb = mason_registry.get_package("codelldb")
            local extension_path = codelldb:get_install_path() .. "/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

            vim.g.rustaceanvim = function()
                return {
                    dap = {
                        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                    },
                    server = {
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        on_attach = function(_, bufnr)
                            vim.keymap.set("n", "<Leader>k", rt.hover_actions.hover_actions, { buffer = bufnr })
                            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                        end,
                    },
                    tools = {
                        hover_actions = {
                            auto_focus = true,
                        },
                    },
                }
            end
        end

    }
}

