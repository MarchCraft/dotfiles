local opts = { noremap = true, silent = true }
-- Normal-mode commands
vim.keymap.set('n', '<C-j>'      ,':MoveLine 1<CR>', opts)
vim.keymap.set('n', '<C-k>'    ,':MoveLine -1<CR>', opts)
vim.keymap.set('x', '<C-j>'   , ':MoveBlock 1<CR>', opts)
vim.keymap.set('x', '<C-k>' , ':MoveBlock -1<CR>', opts)

