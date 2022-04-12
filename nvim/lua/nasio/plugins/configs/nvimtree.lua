vim.g.nvim_tree_git_hl = 1

vim.g.nvim_tree_show_icons = {
	git = 1,
	folders = 1,
	files = 1,
}

require("nvim-tree").setup({
	auto_close = false,
	git = {
		ignore = 2,
	},
	filters = {
		custom = { ".git", "node_modules", ".cache", "*.meta" },
		dotfiles = 1,
	},
	renderer = {
		indent_markers = {
			enable = true,
		},
	},
})
