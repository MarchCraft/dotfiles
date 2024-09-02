return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-neotest/neotest-plenary",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-plenary"),
                    require("rustaceanvim.neotest"),
                },
            })
            vim.keymap.set('n', '<leader>vwt', function() require("neotest").watch.toggle() end, {})
        end
    },
}
