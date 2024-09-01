return {
    -- Rust
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

    -- Java
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
        dependencies = {
            'VonHeikemen/lsp-zero.nvim'
        },
        config = function()
            local jdtls = require("jdtls")
            local jdtlsd = require("jdtls.dap")

            local path = {}

            path.bundles = {
                vim.fn.glob(
                    os.getenv("JAVA_DEBUG") ..
                    "com.microsoft.java.debug.plugin-*.jar", 1)
            };


            local function jdtls_on_attach(client, bufnr)
                jdtls.setup_dap({ hotcodereplace = 'auto' })
                jdtlsd.setup_dap_main_class_configs()

                local opts = { buffer = bufnr }
                vim.keymap.set('n', '<leader>df', "<cmd>lua require('jdtls').test_class()<cr>", opts)
                vim.keymap.set('n', '<leader>dn', "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)


                require('jdtls.dap').setup_dap_main_class_configs()
            end

            local config = {
                cmd = { "jdtls" },
                root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, { upward = true })[1]),
                init_options = {
                    bundles = path.bundles,
                },
                on_attach = jdtls_on_attach,
            }
            jdtls.start_or_attach(config)
        end,
    },
    {
        "saecki/crates.nvim",
        tag = 'v0.3.0',
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
        event = "BufEnter Cargo.toml",
    },
    {
        "prettier/vim-prettier",
        ft = "javascript",
        config = function()
            vim.cmd([[autocmd! BufWritePre,TextChanged,InsertLeave *.js PrettierAsync]])
        end,
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
}
