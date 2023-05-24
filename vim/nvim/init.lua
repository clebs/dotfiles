local fn = vim.fn
local cmd = vim.cmd
local opt = vim.opt
local call = vim.call
local g = vim.g

-- Plugin manager
local data_dir = fn.stdpath('data')
if fn.empty(fn.glob(data_dir .. '/site/autoload/plug.vim')) == 1 then
	cmd('silent !curl -fLo ' ..
		data_dir ..
		'/site/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
	cmd('autocmd VimEnter * PlugInstall --sync | source %')
end
local Plug = fn['plug#']

-- Plugins
call('plug#begin', data_dir .. '/plugged')

-- Appearence and widgets
Plug 'EdenEast/nightfox.nvim'
Plug('catppuccin/nvim', { as = 'catppuccin' }) -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'preservim/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
Plug 'kylechui/nvim-surround'

-- Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'leoluz/nvim-dap-go'

Plug 'jiangmiao/auto-pairs'
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })
Plug('nvim-telescope/telescope-project.nvim')
Plug 'xiyaowong/telescope-emoji.nvim'
Plug 'ellisonleao/glow.nvim'

-- LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'VonHeikemen/lsp-zero.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'onsails/lspkind.nvim'

-- Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'folke/which-key.nvim'

-- GIT
Plug 'sindrets/diffview.nvim'

--  Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

-- Zen
Plug 'folke/zen-mode.nvim'

call('plug#end')

-- Config
opt.shell = 'zsh'
opt.clipboard = 'unnamedplus'                 -- Enables the clipboard between Vim/Neovim and other applications.
opt.completeopt = 'noinsert,menuone,noselect' -- Modifies the auto-complete menu to behave more like an IDE.
opt.cursorline = true                         -- Highlights the current line in the editor
opt.hidden = true                             -- Hide unused buffers
opt.autoindent = true                         -- Indent a new line
opt.inccommand = 'split'                      -- Show replacements in a split screen
opt.mouse = 'a'                               -- Allow to use the mouse in the editor
opt.number = true                             -- shows current line number together with relative numbers
opt.relativenumber = true                     -- Shows line numbers relative to cursor
opt.splitbelow = true
opt.splitright = true                         -- Change the split screen behavior
opt.title = true                              -- Show file title
opt.wildmenu = true                           -- Show a more advance menu
opt.background = 'dark'
-- opt.cc = 80 -- Show at 80 column a border for good code style
opt.spell = false     -- enable spell check (may need to download language package)
opt.ttyfast = true    -- Speed up scrolling in Vim
opt.ignorecase = true -- Ignore case on search
opt.smartcase = true  -- Search is case insensitive when all lowerccase

-- Appearence

-- Transparent BG
cmd [[autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE]]

-- Theme
cmd.colorscheme("catppuccin-frappe")

g.bargreybars_auto = 0
g.NERDSpaceDelims = 1
-- disable netrw at the very start of your init.lua (strongly advised)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])

-- set termguicolors to enable highlight groups
opt.termguicolors = true

-- Scripts
require("nvim-tree").setup({
	sync_root_with_cwd = true,
	update_cwd = true,
	filters = {
		dotfiles = false,
	},
	git = {
		ignore = false,
	},
	actions = {
		open_file = {
			resize_window = true,
		},
	},
})
require("telescope").setup({
	pickers = {
		find_files = {
			hidden = true
		}
	}
})
require("telescope").load_extension("emoji")
require 'telescope'.load_extension('project')
require('lualine').setup({ sections = { lualine_c = { { 'filename', path = 1, file_status = true } } } })
require('dap-go').setup()
require("dapui").setup()
require('diffview').setup()
require('which-key').setup()
require('glow').setup()
require('nvim-surround').setup()
require('zen-mode').setup()
require("symbols-outline").setup()
require("mason").setup()

-- includes
require('keybindings')
require('lsp')
require('debuggers')
require('tree')
