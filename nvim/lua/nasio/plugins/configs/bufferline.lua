local colors = require("tokyonight.colors").setup({})

require("bufferline").setup({
	options = {
		offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
		buffer_close_icon = "",
		modified_icon = "",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		view = "multiwindow",
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(_, _, diagnostics_dict)
			local s = " "
			for e, n in pairs(diagnostics_dict) do
				local sym = e == "error" and " " or (e == "warning" and " " or " ")
				s = s .. n .. sym
			end
			return s
		end,
		show_buffer_close_icons = true,
		show_close_icon = true,
		separator_style = "thin",
    max_name_length = 14,
    max_prefix_length = 13,
		tab_size = 20,
		numbers = "ordinal",
	},
	-- colors setup
	-- for additional highlights see :help bufferline-highlights
	highlights = {
		fill = {
			guibg = colors.bg_dark,
		},
		background = {
			guibg = colors.bg_dark,
		},

		buffer_selected = {
			gui = "bold",
		},
		buffer_visible = {
			guifg = colors.dark3,
			guibg = colors.bg_dark,
		},
		indicator_selected = {
			guifg = colors.bg,
			guibg = colors.bg,
		},

		close_button = {
			guifg = colors.dark3,
			guibg = colors.bg_dark,
		},
		close_button_visible = {
			guifg = colors.dark3,
			guibg = colors.bg_dark,
		},
		close_button_selected = {
			guifg = colors.red,
			guibg = colors.bg,
		},

		separator = {
			guifg = colors.dark3,
			guibg = colors.bg_dark,
		},
		separator_visible = {
			guifg = colors.dark3,
			guibg = colors.bg_dark,
		},
		separator_selected = {
			guifg = colors.dark3,
			guibg = colors.bg,
		},

		-- modified
		modified = {
			guifg = colors.red,
			guibg = colors.bg_dark,
		},
		modified_visible = {
			guifg = colors.red,
			guibg = colors.bg_dark,
		},
		modified_selected = {
			guifg = colors.green,
			guibg = colors.bg,
		},
	},
})
