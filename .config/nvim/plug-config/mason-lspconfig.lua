require("mason-lspconfig").setup()

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- auto using mason
require('mason-lspconfig').setup_handlers({
  function (server)
	  require('lspconfig')[server].setup {
		capabilities = capabilities,
	  }
  end
})
