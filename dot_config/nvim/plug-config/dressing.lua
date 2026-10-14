require("dressing").setup({
  input = {
    get_config = function()
      if vim.bo.filetype == "NvimTree" then
        return { enabled = false }
      end
    end,
  },
})
