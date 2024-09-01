return {
    {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('gitsigns').setup()
        end,
        event = "User GitFile",
        cmd = { "Gitsigns" },
        keys = {
            { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>" },
        }
    },
    {
        "kdheepak/lazygit.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}
