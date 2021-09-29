vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache", "*.meta" }
vim.g.nvim_tree_gitignore = 2
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_allow_resize = 1

vim.g.nvim_tree_show_icons = {
	git = 1,
	folders = 1,
	files = 1,
}

require("nvim-tree").setup({
  auto_close = false,
})
