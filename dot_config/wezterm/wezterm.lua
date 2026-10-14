-- WezTerm 설정 (WSL이 아닌 Linux 전용, chezmoi 관리. Windows는 Windows Terminal을 쓴다)
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback { 'D2Coding Nerd Font', 'D2Coding' }
config.font_size = 12
config.color_scheme = 'Campbell (Gogh)' -- Windows Terminal 기본 색
config.initial_cols = 120
config.initial_rows = 32
config.window_padding = { left = 6, right = 6, top = 4, bottom = 4 }
config.scrollback_lines = 10000
config.use_ime = true
config.audible_bell = 'Disabled'

-- Windows Terminal과 비슷한 단축키
config.keys = {
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = true } },
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = '+', mods = 'ALT|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '_', mods = 'ALT|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
  { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
}

return config
