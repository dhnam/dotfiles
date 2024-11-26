local custom_auto = require'lualine.themes.auto'
local vscode_colors = require'vscode.colors'.get_colors()
custom_auto.normal.b.bg = vscode_colors.vscPopupHighlightGray
custom_auto.normal.c.bg = vscode_colors.vscTabCurrent
custom_auto.insert.b.bg = vscode_colors.vscPopupHighlightGray
custom_auto.insert.c.bg = vscode_colors.vscTabCurrent
custom_auto.visual.b.bg = vscode_colors.vscPopupHighlightGray
custom_auto.replace.b.bg = vscode_colors.vscPopupHighlightGray
custom_auto.replace.c.bg = vscode_colors.vscTabCurrent
custom_auto.command.b.bg = vscode_colors.vscPopupHighlightGray
custom_auto.command.c.bg = vscode_colors.vscTabCurrent
custom_auto.inactive.b.bg = vscode_colors.vscPopupHighlightGray
custom_auto.inactive.c.bg = vscode_colors.vscTabCurrent
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = custom_auto,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress', '%L'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
