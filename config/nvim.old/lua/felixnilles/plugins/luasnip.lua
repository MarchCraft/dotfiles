--straight stolen from 0x5a4/dotfiles
return {
    "L3MON4D3/LuaSnip",
    lazy = true,
    config = function()
        local luasnip = require("luasnip")

        luasnip.config.set_config({
            region_check_events = { "InsertEnter", "CursorHold" }
        })

        require("luasnip.loaders.from_lua").lazy_load({ lazy_paths = "./lua/felixnilles/snippets" })
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip").filetype_extend("rust", {"rustdoc"})
        require("luasnip").filetype_extend("java", {"javadoc"})

    end,
    dependencies = "rafamadriz/friendly-snippets",
    keys = {
        {
            "<C-E>",
            function()
                local luasnip = require("luasnip")
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                end
            end,
            mode = { "i", "s" }
        },
        {
            "<C-S-E>",
            function()
                local luasnip = require("luasnip")
                if luasnip.choice_active() then
                    luasnip.change_choice(-1)
                end
            end,
            mode = { "i", "s" }
        },
    },
}
