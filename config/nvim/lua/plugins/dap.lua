return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require "dap"
            local ui = require "dapui"

            local function find_program(search_paths)
                return function()
                    return coroutine.create(function(run)
                        local maybe_root = vim.fs.find(
                            { "Makefile", "Cargo.lock", "build.zig", "meson.build", ".git" },
                            { upward = true, path = vim.fn.expand("%:p:h") }
                        )

                        local root = next(maybe_root) and vim.fs.dirname(maybe_root[1]) or vim.fn.getcwd()

                        -- find all executables in search paths
                        local executables = {}

                        for _, search in ipairs(search_paths) do
                            local dir = vim.fs.joinpath(root, search)
                            for child, path_type in vim.fs.dir(dir) do
                                if path_type == "file" then
                                    local perm = vim.fn.getfperm(vim.fs.joinpath(dir, child))
                                    if string.match(perm, "x", 3) then
                                        table.insert(executables, vim.fs.joinpath(search, child))
                                    end
                                end
                            end
                        end

                        local theexe;

                        if #executables == 1 then
                            theexe = executables[1]
                            vim.notify("Debugging " .. theexe)
                            coroutine.resume(run, vim.fs.joinpath(root, theexe))
                        elseif #executables > 1 then
                            vim.ui.select(executables, { prompt = "Select executable" }, function(choice)
                                if not choice then
                                    coroutine.resume(run, dap.ABORT)
                                end
                                vim.notify("Debugging " .. choice)
                                coroutine.resume(run, vim.fs.joinpath(root, choice))
                            end)
                        else
                            vim.notify("no executables found in search paths (root was '" .. root .. "')")
                            coroutine.resume(run, dap.ABORT)
                        end
                    end)
                end
            end


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
                    program = find_program({ "." }),
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
            vim.keymap.set("n", "<leader>bc", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end)
            vim.keymap.set("n", "<leader>db", function()
                require("dapui").toggle()
            end)

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
