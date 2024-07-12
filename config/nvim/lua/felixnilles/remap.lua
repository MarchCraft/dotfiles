vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fv" ,vim.cmd.Ex)


vim.keymap.set("n", "<leader>db", ":lua require'dapui'.toggle()<CR>")

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>lrp', ':lua vim.lsp.buf.rename()<CR>', opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", '<leader>ha', ':lua vim.lsp.buf.hover()<CR>', opts)
