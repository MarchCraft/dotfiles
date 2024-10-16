return {
    -- Rust
    {
        'mrcjkb/rustaceanvim',
        lazy = false,
        config = function()
            vim.keymap.set(
                "n",
                "<leader>ca",
                function()
                    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
                    -- or vim.lsp.buf.codeAction() if you don't want grouping.
                end
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
    -- Flutter
    {
        'akinsho/flutter-tools.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
        config = true,
    },
    -- Latex
    {
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_view_method = "zathura"
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_quickfix_mode = 0
            vim.g.tex_conceal = "abdmg"
            vim.g.vimtex_syntax_conceal = {
                accents = 1,
                cites = 1,
                fancy = 1,
                greek = 1,
                ligatures = 1,
                math_delimiters = 1,
                math_super_sub = 1,
                math_symbols = 1,
                spacing = 1,
                styles = 1,
                math_bounds = 0,
                math_fracs = 0,
                sections = 0,
            }
        end,
        lazy = false,
        keys = {
            { "<leader>vt", "<cmd>VimtexCompile<CR>" },
        },
    },
    -- Java
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
        config = function()
            local jdtls = require("jdtls")
            local jdtlsd = require("jdtls.dap")

            local path = {}

            path.bundles = {
                vim.fn.glob(
                    os.getenv("JAVA_DEBUG") ..
                    "com.microsoft.java.debug.plugin-*.jar", 1)
            };


            local lsp_settings = {
                java = {
                    eclipse = {
                        downloadSources = true,
                    },
                    configuration = {
                        updateBuildConfiguration = 'interactive',
                        runtimes = path.runtimes,
                    },
                    maven = {
                        downloadSources = true,
                    },
                    implementationsCodeLens = {
                        enabled = true,
                    },
                    referencesCodeLens = {
                        enabled = true,
                    },
                    format = {
                        enabled = true,
                    }
                },
                signatureHelp = {
                    enabled = false,
                },
                completion = {
                    favoriteStaticMembers = {
                        'org.hamcrest.MatcherAssert.assertThat',
                        'org.hamcrest.Matchers.*',
                        'org.hamcrest.CoreMatchers.*',
                        'org.junit.jupiter.api.Assertions.*',
                        'java.util.Objects.requireNonNull',
                        'java.util.Objects.requireNonNullElse',
                        'org.mockito.Mockito.*',
                    },
                },
                contentProvider = {
                    preferred = 'fernflower',
                },
                extendedClientCapabilities = jdtls.extendedClientCapabilities,
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999,
                    }
                },
                codeGeneration = {
                    toString = {
                        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
                    },
                    useBlocks = true,
                },
            }

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
                settings = lsp_settings,
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
