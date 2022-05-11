local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡄⠀⢠⣶⡄⠀⢤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⡿⠟⠛⠁⠀⣿⣿⣷⠀⠘⠛⠿⢿⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠀⣠⣾⡿⠛⠁⠀⠀⠀⠀⣸⣿⠻⣿⡆⠀⠀⠀⠀⠉⠻⣿⣦⡀⠀⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⣴⣿⠋⠀⠀⠀⠀⠀⠀⢀⣿⡟⠀⢿⣿⠀⠀⠀⠀⠀⠀⠈⠻⣿⣦⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⣾⡿⠁⠀⠀⠀⠀⠀⠀⠀⣸⣿⠃⠀⠸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠘⣿⣧⠀⠀⠀⠀",
	"⠀⠀⠀⣸⣿⠃⠀⠀⠀⠀⠀⠀⠀⢠⣿⡏⠀⠀⠀⢻⣿⡀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡆⠀⠀⠀",
	"⠀⠀⠀⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠁⠀⠀⠀⠘⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀",
	"⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⡏⠀⠀⠀⠀⠀⢻⣿⡀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀",
	"⠀⠀⠀⠛⠛⠀⠀⠀⠀⠀⠀⠀⣾⣿⠀⠀⠀⠀⠀⠀⠈⣿⣧⠀⠀⠀⠀⠀⠀⠀⠛⠛⠀⠀⠀",
	"⠀⠀⠀⠠⣶⣶⣶⣶⣶⣶⣶⣶⣿⡇⠀⠀⠀⠀⠀⠀⠀⢹⣿⣶⣶⣶⣶⣶⣶⣶⣶⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠹⣿⣏⠉⠉⠉⠉⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣯⠉⠉⠉⢉⣽⣿⠃⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠘⢿⣷⣄⠀⢸⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡆⠀⣠⣾⡿⠁⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠀⠀⠙⠿⣷⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣷⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀",
	"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀",
}

dashboard.section.buttons.val = {
	dashboard.button("SPC f f", "  Find File  ", ":Telescope find_files<CR>"),
	dashboard.button("SPC f o", "  Recent File  ", ":Telescope oldfiles<CR>"),
	dashboard.button("SPC f w", "  Find Word  ", ":Telescope live_grep<CR>"),
	dashboard.button("SPC b m", "  Bookmarks  ", ":Telescope marks<CR>"),
	dashboard.button("SPC t h", "  Themes  ", ":Telescope themes<CR>"),
	dashboard.button("SPC e s", "  Settings", ":e $MYVIMRC | :cd %:p:h <CR>"),
}

dashboard.config.opts.noautocmd = true

vim.cmd([[autocmd User AlphaReady echo 'ready']])

alpha.setup(dashboard.config)
