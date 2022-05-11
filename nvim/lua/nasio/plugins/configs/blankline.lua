require("indent_blankline").setup({
	indentLine_enabled = 1,
	char = "▏",
	filetype_exclude = {
		"lspinfo",
		"packer",
		"checkhealth",
		"help",
		"man",
		"",
		"terminal",
		"alpha",
		"TelescopePrompt",
		"TelescopeResults",
	},
	buftype_exclude = { "terminal" },
	show_trailing_blankline_indent = false,
	show_first_indent_level = false,
})
