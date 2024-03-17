require('which-key').setup({
	layout = {
		height = { max = 10 }
	}
})

require('which-key').register({
	-- Telescope
	t = {
		name = "Telescope",
		r = {"<cmd>Telescope lsp_references<CR>", "Find symbol reference under cursor"},
		d = {"<cmd>Telescope lsp_definitions<CR>", "Find global definition under cursor"},
		i = {"<cmd>Telescope lsp_implementations<CR>", "Find implementation under cursor"},
		t = {"<cmd>Telescope lsp_type_definitions<CR>", "Find type definition under cursor"},
		S = {"<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Search symbols"},
		G = {"<cmd>Telescope live_grep<CR>", "Live grep"},
		T = {"<cmd>Telescope<CR>", "See all telescope"}
	}
}, { prefix = "<leader>" })
