call plug#begin('~/.vim/plugged')
	"file explorer
	Plug 'nvim-tree/nvim-tree.lua'
	"tagtree (F8)
	Plug 'preservim/tagbar'
	"treesitter - highlighter
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	"Context viewer
	Plug 'nvim-treesitter/nvim-treesitter-context'
	"Icon for whichkey
	Plug 'echasnovski/mini.icons'
	"key preview
	Plug 'folke/which-key.nvim'
	"Scrollbar
	Plug 'dstein64/nvim-scrollview'
	"Bottom line (replace airline)
	Plug 'nvim-lualine/lualine.nvim'
	"Theme
	Plug 'Mofiqul/vscode.nvim'
	Plug 'nvim-tree/nvim-web-devicons'
	"Tab bar (buffer)
	Plug 'akinsho/bufferline.nvim'
	"Cscope (<C-\>)
	Plug 'dhananjaylatkar/cscope_maps.nvim'
	Plug 'ludovicchabant/vim-gutentags'
	"{}()[] pair
	Plug 'windwp/nvim-autopairs'
	"Startup time
	Plug 'dstein64/vim-startuptime'

	"LSP
	Plug 'neovim/nvim-lspconfig'
	"Autocomplete
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	"Snippet
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'
	"Auto LSP install
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
	"For filtering UI
	Plug 'stevearc/dressing.nvim'

	"Fuzzy search
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim', {'frozen' : 1, 'tag': '0.1.8' }

	"Project
	Plug 'ahmedkhalf/project.nvim'
call plug#end()

let mapleader=" "
source ~/.config/nvim/plug-config/treesitter.lua
source ~/.config/nvim/plug-config/vscode.lua
source ~/.config/nvim/plug-config/bufferline.lua
source ~/.config/nvim/plug-config/lualine.lua
source ~/.config/nvim/plug-config/cscope.lua
source ~/.config/nvim/plug-config/tagbar.vim
source ~/.config/nvim/plug-config/mason.lua
source ~/.config/nvim/plug-config/mason-lspconfig.lua
source ~/.config/nvim/plug-config/nvimtree.lua
source ~/.config/nvim/plug-config/cmp.lua
source ~/.config/nvim/plug-config/dressing.lua
source ~/.config/nvim/plug-config/telescope.lua
source ~/.config/nvim/plug-config/project.lua
source ~/.config/nvim/plug-config/autopair.lua
source ~/.config/nvim/plug-config/lspconfig.lua
source ~/.config/nvim/plug-config/whichkey.lua
source ~/.config/nvim/plug-config/scrollbar.lua

set ts=4
set shiftwidth=4
set showcmd
set timeoutlen=500
set mouse=nv
set mousemodel=popup_setpos
set number
