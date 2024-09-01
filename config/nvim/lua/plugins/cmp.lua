return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        cmd = { "CmpStatus" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-buffer" }, { "hrsh7th/cmp-cmdline" },
            { "saadparwaiz1/cmp_luasnip" },
            {
                "petertriho/cmp-git",
                opts = {}
            },
        },
        config = function()
            local cmp = require("cmp")

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
        end,
    }
}
