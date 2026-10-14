-- cscope가 없는 환경(Windows 등)에서는 gutentags가 매번 오류를 내므로 통째로 끈다.
if vim.fn.executable("cscope") == 1 then
	vim.g.gutentags_modules = {"cscope_maps"} -- This is required. Other config is optional
	vim.g.gutentags_cscope_build_inverted_index_maps = 1
	vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/gutentags"
	vim.g.gutentags_file_list_command = "fd -e c -e h"

	require("cscope_maps").setup({
		prefix="<c-\\>"
	})
else
	vim.g.gutentags_enabled = 0
end
