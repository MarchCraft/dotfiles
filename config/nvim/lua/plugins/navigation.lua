return {
    {
        'mbbill/undotree',
        lazy = false,
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, desc = "Undotree" },
        },
    },
    {
        'stevearc/oil.nvim',
        lazy = false,
        config = true,
        keys = {
            { "<leader>fv", vim.cmd.Oil, desc = "Oil" },
        },
    },
}
