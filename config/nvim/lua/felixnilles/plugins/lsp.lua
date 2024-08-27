return {
    {
        "neovim/nvim-lspconfig",
        event = "User File",
        config = function()
            vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
            vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]
            vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]


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
            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or border
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        event = "User File",
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
            'hrsh7th/cmp-nvim-lsp-signature-help'
        },
        config = function()
            local lsp_zero = require('lsp-zero')

            lsp_zero.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }

                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
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

            require('lspconfig').nil_ls.setup {
                autostart = true,
                capabilities = caps,
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

            local lspconfig = require("lspconfig")
            lspconfig.marksman.setup({})
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
                    }
                }
            })

            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

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
                    { name = 'path' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'jdtls' },
                    { name = 'luasnip', priority = 100 },
                    { name = "copilot", group_index = 2, priority = 100 },
                },
                formatting = lsp_zero.cmp_format(),
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                }),
                ["<C-e>"] = cmp.mapping.close(),
            })
            lsp_zero.setup();
        end
    },
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
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
            vim.keymap.set(
                "n",
                "<Leader>ol",
                require("lsp_lines").toggle,
                { desc = "Toggle lsp_lines" }
            )
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "User File",
        opts = {
            debug = false,                                              -- set to true to enable debug logging
            log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
            -- default is  ~/.cache/nvim/lsp_signature.log
            verbose = false,                                            -- show debug line number

            bind = true,                                                -- This is mandatory, otherwise border config won't get registered.
            -- If you want to hook lspsaga or other signature handler, pls set to false
            doc_lines = 10,                                             -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
            -- set to 0 if you DO NOT want any API comments be shown
            -- This setting only take effect in insert mode, it does not affect signature help in normal
            -- mode, 10 by default

            max_height = 12,                       -- max height of signature floating_window
            max_width = 80,                        -- max_width of signature floating_window, line will be wrapped if exceed max_width
            -- the value need >= 40
            wrap = true,                           -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
            floating_window = true,                -- show hint in a floating window, set to false for virtual text only mode

            floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
            -- will set to true when fully tested, set to false will use whichever side has more space
            -- this setting will be helpful if you do not want the PUM and floating win overlap

            floating_window_off_x = -1, -- adjust float windows x position.
            -- can be either a number or function
            floating_window_off_y = 0,  -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
            -- can be either number or function, see examples

            close_timeout = 4000,                      -- close floating window after ms when laster parameter is entered
            fix_pos = false,                           -- set to true, the floating window will not auto-close until finish all parameters
            hint_enable = true,                        -- virtual hint enable
            hint_prefix = "",                          -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
            hint_scheme = "String",
            hint_inline = function() return false end, -- should the hint be inline(nvim 0.10 only)?  default false
            -- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
            -- return 'right_align' to display hint right aligned in the current line
            hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
            handler_opts = {
                border = "rounded"                        -- double, rounded, single, shadow, none, or a table of borders
            },

            always_trigger = false,                   -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

            auto_close_after = nil,                   -- autoclose signature float win after x sec, disabled if nil.
            extra_trigger_chars = {},                 -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
            zindex = 200,                             -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

            padding = '',                             -- character to pad on left and right of signature can be ' ', or '|'  etc

            transparency = nil,                       -- disabled by default, allow floating win transparent value 1~100
            shadow_blend = 36,                        -- if you using shadow as border use this set the opacity
            shadow_guibg = 'Black',                   -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
            timer_interval = 200,                     -- default timer check interval set to lower value if you want to reduce latency
            toggle_key = nil,                         -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
            toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
            -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
            -- may not popup when typing depends on floating_window setting

            select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
            move_cursor_key = nil,      -- imap, use nvim_set_current_win to move cursor between current win and floating
        },
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    }



}
