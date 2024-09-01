return {
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
    "svermeulen/vim-cutlass",
    {
        "tpope/vim-commentary",
        keys = { { "gc", nil, mode = { "n", "x", "o" } } }
    },
    {
        'fedepujol/move.nvim',
        config = function()
            require('move').setup({})
            local opts = { noremap = true, silent = true }
            vim.keymap.set('v', '<S-j>', ':MoveBlock(1)<CR>', opts)
            vim.keymap.set('v', '<S-k>', ':MoveBlock(-1)<CR>', opts)
        end
    }
}
