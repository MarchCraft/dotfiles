require('telescope').setup{
    defaults = {
        file_ignore_patterns = { "node_modules", "dist", "build", "target", "vendor" },
        mappings = {
            i = {
                ["<esc>"] = require('telescope.actions').close,
                ["<C-j>"] = require('telescope.actions').move_selection_next,
                ["<C-k>"] = require('telescope.actions').move_selection_previous,
            },
            n = {
                ["<esc>"] = require('telescope.actions').close,
                ["<C-j>"] = require('telescope.actions').move_selection_next,
                ["<C-k>"] = require('telescope.actions').move_selection_previous,
            }
        }
    },
    pickers = {
        find_files = {
            --find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
        },

    }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {  })
vim.api.nvim_set_keymap('n', '<Leader>ff', ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({search = vim.fn.input("Grep > ") });
end)

