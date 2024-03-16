local c = require('vscode.colors').get_colors()
require("scrollbar").setup({
	handle = {
		blend = 0,
		color = c.vscDimHighlight,
	},
	marks = {
		Cursor = { color = c.vscMediumBlue },
		Search = { color = c.vscOrange },
		Error = { color = c.vscRed },
		Warn = { color = c.vscYellowOrange },
		Info = { color = c.vscBlue },
		Hint = { color = c.vscBlue },
		Misc = { color = c.vscBlueGreen },
	},
	handlers = { gitsigns = true },
})
