vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fv" ,vim.cmd.Ex)





vim.keymap.set("n", "<C-r>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<C-c>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")

vim.keymap.set("n", "<leader>db", ":lua require'dapui'.toggle()<CR>")

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
local opts = { noremap = true, silent = true }
-- Normal-mode commands
vim.keymap.set('n', '<C-j>'      ,':MoveLine 1<CR>', opts)
vim.keymap.set('n', '<C-k>'    ,':MoveLine -1<CR>', opts)
vim.keymap.set('x', '<C-j>'   , ':MoveBlock 1<CR>', opts)
vim.keymap.set('x', '<C-k>' , ':MoveBlock -1<CR>', opts)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {  })
vim.api.nvim_set_keymap('n', '<Leader>ff', ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({search = vim.fn.input("Grep > ") });
end)


