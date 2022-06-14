require("nvim-tree").setup({
	git = {
		ignore = true,
	},
	filters = {
		custom = { ".git", "node_modules", ".cache", "*.meta" },
		dotfiles = true,
	},
	renderer = {
		highlight_git = true,
		indent_markers = {
			enable = true,
		},
		icons = {
			show = {
				file = true,
				folder = true,
				git = true,
			},
		},
	},
})
