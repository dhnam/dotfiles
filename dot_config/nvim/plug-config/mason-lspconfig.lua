-- cmp의 자동완성 기능(스니펫 등)을 모든 LSP 서버에 알린다. (Neovim 0.11+)
-- mason-lspconfig가 설치된 서버를 자동으로 켜기 전에 설정해야 한다.
vim.lsp.config('*', {
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require("mason-lspconfig").setup()
