-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show which line your cursor is on
vim.opt.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {
        clear = true
    }),
    callback = function()
        vim.highlight.on_yank()
    end
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system {'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath}
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.keymap.set('n', '<C-j>', ':call VSCodeNotify("workbench.action.navigateDown")<CR>')
vim.keymap.set('x', '<C-j>', ':call VSCodeNotify("workbench.action.navigateDown")<CR>')
vim.keymap.set('n', '<C-k>', ':call VSCodeNotify("workbench.action.navigateUp")<CR>')
vim.keymap.set('x', '<C-k>', ':call VSCodeNotify("workbench.action.navigateUp")<CR>')
vim.keymap.set('n', '<C-h>', ':call VSCodeNotify("workbench.action.navigateLeft")<CR>')
vim.keymap.set('x', '<C-h>', ':call VSCodeNotify("workbench.action.navigateLeft")<CR>')
vim.keymap.set('n', '<C-l>', ':call VSCodeNotify("workbench.action.navigateRight")<CR>')
vim.keymap.set('x', '<C-l>', ':call VSCodeNotify("workbench.action.navigateRight")<CR>')

vim.keymap.set('n', '<C-w>_', ':<C-u>call VSCodeNotify("workbench.action.toggleEditorWidths")<CR>')

vim.keymap.set('n', '<Space>', ':call VSCodeNotify("whichkey.show")<CR>')
vim.keymap.set('x', '<Space>', ':call VSCodeNotify("whichkey.show")<CR>')

-- vim.cmd [[source $HOME/.config/nvim/vscode/settings.vim]]

require('lazy').setup({{ -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [']quote
        --  - ci'  - [C]hange [I]nside [']quote
        require('mini.ai').setup {
            n_lines = 500
        }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup()

        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        statusline.setup {
            use_icons = true

        }

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
            return ''
        end

        -- ... and there is more!
        --  Check out: https://github.com/echasnovski/mini.nvim
    end
}, { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
        ensure_installed = {'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc'},
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = {'ruby'}
        },
        indent = {
            enable = true,
            disable = {'ruby'}
        }
    },
    config = function(_, opts)
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

        ---@diagnostic disable-next-line: missing-fields
        require('nvim-treesitter.configs').setup(opts)

        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end
}, {'github/copilot.vim'}})
