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
	cmd('source ' .. data_dir .. '/site/autoload/plug.vim')
	cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end
local Plug = fn['plug#']

-- Plugins
call('plug#begin', data_dir .. '/plugged')

-- Common
Plug 'nvim-neotest/nvim-nio'
Plug('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'pysan3/pathlib.nvim'

-- Appearence and widgets
Plug 'EdenEast/nightfox.nvim'
Plug('catppuccin/nvim', { as = 'catppuccin' }) -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
Plug('neanias/everforest-nvim', { branch = 'main' })
Plug('folke/tokyonight.nvim', { branch = 'main' })
Plug 'ellisonleao/gruvbox.nvim'
Plug('rose-pine/neovim', { as = 'rose-pine' })
Plug('maxmx03/solarized.nvim', { branch = 'main' })


Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'preservim/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'kylechui/nvim-surround'
Plug 'startup-nvim/startup.nvim'

-- Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'

-- Telescope
Plug 'jiangmiao/auto-pairs'
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })
Plug('nvim-telescope/telescope-project.nvim')
Plug('ThePrimeagen/harpoon', { branch = 'harpoon2' })
Plug 'xiyaowong/telescope-emoji.nvim'

-- Markdown
Plug "OXY2DEV/markview.nvim"

-- LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'onsails/lspkind.nvim'

-- Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'folke/which-key.nvim'

-- GIT
Plug 'sindrets/diffview.nvim'
Plug 'APZelos/blamer.nvim'

-- Zen
Plug 'folke/zen-mode.nvim'

-- Org mode
Plug('nvim-neorg/neorg', { run = ':Neorg sync-parsers' })
Plug 'nvim-neorg/lua-utils.nvim'

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
opt.spell = false         -- enable spell check (may need to download language package)
opt.ttyfast = true        -- Speed up scrolling in Vim
opt.ignorecase = true     -- Ignore case on search
opt.smartcase = true      -- Search is case insensitive when all lowerccase
opt.foldenable = false    -- Disable folding (smehow neorg set everything to fold)
-- opt.conceallevel = 2      -- conceal level for org mode
opt.concealcursor = "nvc" -- conceal cursor for org mode
opt.diffopt = "vertical" -- vertical split on diff tool

-- Git blamer
g.blamer_show_in_visual_modes = 0
g.blamer_show_in_insert_modes = 0
g.blamer_date_format = '%d.%m.%y'

-- Appearence

-- Theme
require('theme')

g.bargreybars_auto = 0
g.NERDSpaceDelims = 1
-- disable netrw at the very start of your init.lua (strongly advised)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
cmd('hi NvimTreeNormal guibg=NONE ctermbg=NONE')

-- highlight yanked text for 150ms using the "Visual" highlight group
cmd [[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=250})
augroup END
]]

-- set termguicolors to enable highlight groups
opt.termguicolors = true

-- Plugin setup
require("nvim-tree").setup({
	-- changes the root of the tree when changing dir in the terminal (e.g. using cd)
	sync_root_with_cwd = true,
	update_cwd = true,
	filters = {
		dotfiles = false,
	},
	git = {
		ignore = false,
	},
	actions = {
		change_dir = {
			enable = true,
			global = true,
			restrict_above_cwd = false,
		},
		open_file = {
			resize_window = true,
		},
	},
	view = { adaptive_size = true },
})
require("telescope").setup({
	pickers = {
		find_files = {
			hidden = true,
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
		diagnostics = {
			sort_by = 'severity',
		},
	}
})
require('harpoon'):setup()
require('lualine').setup({ sections = { lualine_c = { { 'filename', path = 1, file_status = true } } }, options = { theme = "auto" } })
require('diffview').setup()
require('which-key').setup()
require('markview').setup({
		-- silence complaint that treesitter is loaded before this
		experimental = { check_rtp_message = false },
	})
require('nvim-surround').setup()
require('zen-mode').setup()
require("symbols-outline").setup()
require("mason").setup()
require("startup").setup({ theme = "nvim" })
require("neorg").setup({
	load = {
		["core.defaults"] = {},
		["core.concealer"] = {},
		["core.completion"] = { config = { engine = 'nvim-cmp', name = "[Norg]" } },
		["core.summary"] = {},
		["core.dirman"] = {
			config = {
				workspaces = {
					notes = "~/Documents/notes",
				},
				default_workspace = "notes",
			},
		},
		["core.integrations.nvim-cmp"] = {},
		["core.integrations.treesitter"] = {},
		["core.syntax"] = {},
	},
})
-- Fix for detecting neorg files. This does not work, using autocmd for now
-- vim.filetype.add({ extensions = { norg = "lua" } })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.norg",
	command = "setfiletype norg",
})

-- includes
require('keybindings')
require('lsp')
require('completion')
require('snippets')
require('diagnostics')
require('highlights')
require('debuggers')
