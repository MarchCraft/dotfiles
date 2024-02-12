return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap"
        },
        config = function ()
            require("dapui").setup()
            local dap,dapui = require("dap"), require("dapui")
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
            vim.keymap.set("n", "<Leader>dt", ':DapToggleBreakpoint<CR>')
            vim.keymap.set("n", "<Leader>dx", ':DapTerminate<CR>')
            vim.keymap.set("n", "<Leader>do", ':DapStepOver<CR>')


        end
    }
}
