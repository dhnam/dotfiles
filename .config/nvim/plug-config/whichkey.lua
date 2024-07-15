require('which-key').setup({
	layout = {
		height = { max = 10 }
	}
})

require('which-key').add({
	-- Telescope
    { "<leader>t", group = "Telescope" },
    { "<leader>tG", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
    { "<leader>tS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Search symbols" },
    { "<leader>tT", "<cmd>Telescope<CR>", desc = "See all telescope" },
    { "<leader>td", "<cmd>Telescope lsp_definitions<CR>", desc = "Find global definition under cursor" },
    { "<leader>ti", "<cmd>Telescope lsp_implementations<CR>", desc = "Find implementation under cursor" },
    { "<leader>tr", "<cmd>Telescope lsp_references<CR>", desc = "Find symbol reference under cursor" },
    { "<leader>tt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Find type definition under cursor" },
})

require('which-key').add({
    { "<C-\\><C-n>", desc = "Normal mode", mode = "t" },
    { "<C-\\><C-o>", desc = "Normal mode for a operation", mode = "t" },
  })
