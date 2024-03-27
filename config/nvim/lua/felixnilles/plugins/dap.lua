return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        dependencies = {
            "mfussenegger/nvim-dap"
        },
        config = function ()
            require("dapui").setup()
            local dap,dapui = require("dap"), require("dapui")
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            vim.keymap.set("n", "<C-r>", ":lua require'dap'.continue()<CR>")
            vim.keymap.set("n", "<Leader>dt", ':DapToggleBreakpoint<CR>')
            vim.keymap.set("n", "<Leader>dx", ':DapTerminate<CR>')
            vim.keymap.set("n", "<Leader>do", ':DapStepOver<CR>')


        end
    }
}
