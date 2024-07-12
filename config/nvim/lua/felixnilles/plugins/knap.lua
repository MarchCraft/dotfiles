return {
    {
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_view_method = "zathura"
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
    }
}
