return {
    { "VonHeikemen/lsp-zero.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
        { "lukas-reineke/lsp-format.nvim", config = true },
    },
    event = "VeryLazy",
    config = function()
        local lsp_zero = require('lsp-zero')

        lsp_zero.on_attach(function(client, bufnr)
            local opts = {buffer = bufnr, remap = false}

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            if client.name == "jdtls" then
                require("jdtls").setup_dap { hotcodereplace = "auto" }
                require("jdtls.dap").setup_dap_main_class_configs()
                vim.lsp.codelens.refresh()
            end

        end)

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                'tsserver',
                'rust_analyzer',
                'jdtls',
                'ansiblels',
                'bashls',
                'cmake',
                'cssls',
                'docker_compose_language_service',
                'dockerls',
                'html',
                'jsonls',
                'lua_ls',
                'texlab',
                'tsserver'
            },
            handlers = {
                lsp_zero.default_setup,
                lua_ls = function()
                    local lua_opts = lsp_zero.nvim_lua_ls()
                    require('lspconfig').lua_ls.setup(lua_opts)
                end,
                jdtls = lsp_zero.noop,
            }
        })
        local cmp = require('cmp')
        local cmp_select = {behavior = cmp.SelectBehavior.Select}

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            -- Shamelessly stolen from the nvchad config
            window = {
                completion = {
                    border = {
                        { "╭", "CmpBorder" },
                        { "─", "CmpBorder" },
                        { "╮", "CmpBorder" },
                        { "│", "CmpBorder" },
                        { "╯", "CmpBorder" },
                        { "─", "CmpBorder" },
                        { "╰", "CmpBorder" },
                        { "│", "CmpBorder" },
                    }
                },
                documentation = {
                    border = {
                        { "╭", "CmpDocBorder" },
                        { "─", "CmpDocBorder" },
                        { "╮", "CmpDocBorder" },
                        { "│", "CmpDocBorder" },
                        { "╯", "CmpDocBorder" },
                        { "─", "CmpDocBorder" },
                        { "╰", "CmpDocBorder" },
                        { "│", "CmpDocBorder" },
                    },
                    winhighlight = "Normal:CmpDoc",
                },
            },
            sources = {
                {name = 'path'},
                {name = 'nvim_lsp'},
                {name = 'nvim_lua'},
            },
            formatting = lsp_zero.cmp_format(),
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ["<C-CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    --['<C-Enter>'] = cmp.mapping.confirm({ select = true }),
                    select = true,
                }),
            }),
            ["<C-e>"] = cmp.mapping.close(),
        })
        lsp_zero.setup();

    end },
    {
        "saecki/crates.nvim",
        tag = 'v0.3.0',
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
        event = "BufEnter Cargo.toml",
    },
    {
        "theRealCarneiro/hyprland-vim-syntax",
        ft = "hypr"
    },

}
