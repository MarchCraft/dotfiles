-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {
        "loctvl842/monokai-pro.nvim",
        config = function()
            require("monokai-pro").setup()
        end
    }
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},

        }
    }
    use('christoomey/vim-tmux-navigator')
    use('nvim-lua/plenary.nvim')
    use('github/copilot.vim')
    use {
        "savq/paq-nvim",
        "frabjous/knap"
    }
    use('andweeb/presence.nvim')
    use({
        'ojroques/nvim-osc52',
        config = function()
            require('osc52').setup()
            local function copy()
                if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
                    require('osc52').copy_register('"')
                end
            end

            vim.api.nvim_create_autocmd('TextYankPost', { callback = copy })
        end
    })

use('prichrd/netrw.nvim')
use('nvim-tree/nvim-web-devicons')
use('nvim-treesitter/nvim-treesitter-context')
use('michaelb/sniprun', {run = 'sh install.sh'})
use('mfussenegger/nvim-dap')
use 'mfussenegger/nvim-jdtls' -- Java LSP

use 'rcarriga/nvim-dap-ui' -- Better UI for DAP
use 'theHamsta/nvim-dap-virtual-text'
use 'mfussenegger/nvim-dap-python'
use 'simrat39/rust-tools.nvim'
use 'ldelossa/nvim-dap-projects'
use 'rcarriga/nvim-notify'
use "hinell/move.nvim"
-- install without yarn or npm
use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
})

use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
use {
    'akinsho/flutter-tools.nvim',
    requires = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
}
use {
  "folke/noice.nvim",
  opts = {
    -- add any options here
  },
  requires = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    "nvim-notify", -- is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
    }
}

use {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end
}

use 'vappolinario/cmp-clippy'

use "lukas-reineke/indent-blankline.nvim"

use 'voldikss/vim-floaterm'

use 'f-person/git-blame.nvim'

use { "catppuccin/nvim", as = "catppuccin" }

use {
  'tanvirtin/vgit.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  }
}

end)
