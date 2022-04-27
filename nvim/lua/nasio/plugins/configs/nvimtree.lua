vim.g.nvim_tree_git_hl = 1

vim.g.nvim_tree_show_icons = {
	git = 1,
	folders = 1,
	files = 1,
}

require("nvim-tree").setup({
	git = {
		ignore = true,
	},
	filters = {
		custom = { ".git", "node_modules", ".cache", "*.meta" },
		dotfiles = true,
	},
	renderer = {
		indent_markers = {
			enable = true,
		},
	},
})
