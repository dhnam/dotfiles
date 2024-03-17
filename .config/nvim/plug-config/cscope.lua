vim.g.gutentags_modules = {"cscope_maps"} -- This is required. Other config is optional
vim.g.gutentags_cscope_build_inverted_index_maps = 1
vim.g.gutentags_cache_dir = vim.fn.expand("~/code/.gutentags")
vim.g.gutentags_file_list_command = "fd -e c -e h"

require("cscope_maps").setup({
	prefix="<c-\\>"
})
