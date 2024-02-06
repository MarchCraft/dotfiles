return {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
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
