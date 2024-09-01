return {
    {
        "j-hui/fidget.nvim",
        config = true,
        tag = "legacy",
        event = "LspAttach",
    },
    {
        "folke/trouble.nvim",
        event = "BufRead",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
        "ray-x/lsp_signature.nvim",
        event = "User File",
        opts = {},
        config = function(_, opts) require'lsp_signature'.setup(opts) end
    },

    ---------------------------------------------------------------------------
    ------------------------- LSP Config---------------------------------------
    ---------------------------------------------------------------------------

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        event = "User File",
        config = function()
            vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
            vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]
            vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                end,
            })


            local border = {
                { "╭", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╮", "FloatBorder" },
                { "│", "FloatBorder" },
                { "╯", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╰", "FloatBorder" },
                { "│", "FloatBorder" },
            }

            local lspconfig = require("lspconfig")
            local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
                    }
                }
            })

            require('lspconfig').nil_ls.setup {
                autostart = true,
                capabilities = lsp_capabilities,
                settings = {
                    ['nil'] = {
                        testSetting = 42,
                        formatting = {
                            command = { "nixpkgs-fmt" },
                        },
                    },
                },
            }

            require('lspconfig').nixd.setup {}
        end,
    },
}
