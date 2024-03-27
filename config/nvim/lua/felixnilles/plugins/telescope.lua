return {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        {
            '<leader>ff', "", callback = function()
                require('telescope.builtin').find_files({
                    hidden = true,
                    no_ignore = true,
                    no_parent_ignore = true,
                })
            end
        },
        {
            '<leader>fs', "", callback = function()
                require("telescope.builtin").grep_string({search = vim.fn.input("Grep > ") });
            end
        }
    },
    cmd = 'Telescope',
    config = function ()
        -- vim.api.nvim_set_keymap('n', '<Leader>ff', ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', {noremap = true, silent = true})
        -- vim.keymap.set('n', '<C-f>', builtin.git_files, {})
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
    end
}
