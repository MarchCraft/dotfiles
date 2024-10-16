function program(cmd)
    local core = require("core")
    vim.cmd("!" .. cmd)
    local root_path = core.file.root_path()
    local target_dir = root_path .. "./."
    if core.file.file_or_dir_exists(target_dir) then
        local executable = {}
        for path, path_type in vim.fs.dir(target_dir) do
            if path_type == "file" then
                local perm = vim.fn.getfperm(target_dir .. path)
                if string.match(perm, "x", 3) then
                    table.insert(executable, path)
                end
            end
        end
        if #executable == 1 then
            return target_dir .. executable[1]
        else
            vim.ui.select(executable, { prompt = "Select executable" }, function(choice)
                if not choice then
                    return
                end
                return target_dir .. choice
            end)
        end
    else
        vim.ui.input({ prompt = "Path to executable: ", default = root_path .. "./." }, function(input)
            return input
        end)
    end
end

return {
    "niuiic/core.nvim",
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "niuiic/core.nvim",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require "dap"
            local ui = require "dapui"

            local dap = require('dap')

            dap.adapters.codelldb = {
                type = 'server',
                port = "${port}",
                executable = {
                    command = 'codelldb',
                    args = { "--port", "${port}" },
                }
            }

            dap.configurations.c = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = program("make"),
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
            }

            require("dapui").setup()

            require("nvim-dap-virtual-text").setup {
                display_callback = function(variable)
                    local name = string.lower(variable.name)
                    local value = string.lower(variable.value)
                    if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
                        return "*****"
                    end

                    if #variable.value > 15 then
                        return " " .. string.sub(variable.value, 1, 15) .. "... "
                    end

                    return " " .. variable.value
                end,
            }

            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)

            vim.keymap.set("n", "<leader>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.keymap.set("n", "<F5>", dap.continue)
            vim.keymap.set("n", "<F6>", dap.step_into)
            vim.keymap.set("n", "<F7>", dap.step_over)
            vim.keymap.set("n", "<F8>", dap.step_out)
            vim.keymap.set("n", "<F9>", dap.step_back)
            vim.keymap.set("n", "<F12>", dap.restart)

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
        end,
    },
}
