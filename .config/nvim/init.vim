call plug#begin('~/.vim/plugged')
	"Plug 'sainnhe/gruvbox-material'
	"Plug 'tpope/vim-fugitive'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	"Plug 'preservim/nerdtree'
	Plug 'nvim-tree/nvim-tree.lua'
	Plug 'preservim/tagbar'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'folke/which-key.nvim'
	Plug 'petertriho/nvim-scrollbar'
	Plug 'nvim-lualine/lualine.nvim'
	Plug 'Mofiqul/vscode.nvim'
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'akinsho/bufferline.nvim'
	Plug 'dhananjaylatkar/cscope_maps.nvim'
	Plug 'ludovicchabant/vim-gutentags'

	Plug 'lewis6991/gitsigns.nvim'
	Plug 'tmsvg/pear-tree'
	Plug 'dstein64/vim-startuptime'
call plug#end()

let mapleader=" "
source ~/.config/nvim/plug-config/treesitter.lua
source ~/.config/nvim/plug-config/coc.vim
source ~/.config/nvim/plug-config/whichkey.lua
source ~/.config/nvim/plug-config/vscode.lua
source ~/.config/nvim/plug-config/bufferline.lua
source ~/.config/nvim/plug-config/scrollbar.lua
source ~/.config/nvim/plug-config/lualine.lua
source ~/.config/nvim/plug-config/cscope.lua
source ~/.config/nvim/plug-config/tagbar.vim
source ~/.config/nvim/plug-config/nvimtree.lua

set ts=4
set shiftwidth=4
set showcmd
set timeoutlen=500
set mouse=nv
set mousemodel=popup_setpos
set number


