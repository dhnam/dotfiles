vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, {desc="Open diagnostic"})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {desc="Goto prev diagnostic"})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {desc="Goto next diagnostic"})
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, {desc="Diagnostic location list"})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, desc = "" }
	opts.desc = "Jump to declaration"
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	opts.desc = "Jump to definition"
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	opts.desc = "Hover information"
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	opts.desc = "Jump to implementation"
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	opts.desc = "Show signature help"
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
	opts.desc = "Add workspace folder"
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
	opts.desc = "Remove workspace folder"
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
	opts.desc = "Workspace folder list"
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
	opts.desc = "Show type definition"
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
	opts.desc = "Rename"
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
	opts.desc = "Select code action"
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
	opts.desc = "Show references"
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	opts.desc = "Format"
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
