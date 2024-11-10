return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            {
                '<leader>ff',
                "",
                callback = function()
                    require('telescope.builtin').find_files({
                        hidden = true,
                        no_ignore = true,
                        no_parent_ignore = true,
                    })
                end
            },
            {
                '<leader>fs',
                "",
                callback = function()
                    require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") });
                end
            },
            {
                '<C-p>',
                "",
                callback = function()
                    require("telescope.builtin").git_files({})
                end
            },
        },
        cmd = 'Telescope',
        config = function()
            require('telescope').setup {
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
                        find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
                    },

                }
            }
        end
    },
    {
        "folke/todo-comments.nvim",
        event = "User File",
        keys = {
            { "<leader>tt", "<cmd>TodoTelescope<CR>" },
        },
        dependencies = "nvim-lua/plenary.nvim",
        config = true
    },
}
