require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	highlight = {
		enable = true, -- false will disable the whole extension
		use_languagetree = true,
	},
	indent = {
		enable = true,
	},
})
