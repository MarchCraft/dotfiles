
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fv" ,vim.cmd.Ex)

local jdtls = require("jdtls")
vim.keymap.set("n", "<leader>vc", jdtls.test_class, bufopts, "Test class (DAP)")
vim.keymap.set("n","<leader>vm", jdtls.test_nearest_method, bufopts, "Test method (DAP)")

vim.keymap.set("n", "<C-r>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<C-c>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")

vim.keymap.set("n", "<leader>db", ":lua require'dapui'.toggle()<CR>")
