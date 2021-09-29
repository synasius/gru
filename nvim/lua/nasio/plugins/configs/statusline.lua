local colors = require("tokyonight.colors").setup({})
local lsp = require("feline.providers.lsp")

-- icons and style taken from nvchad
local icon_styles = {
	left = "",
	right = "",
	main_icon = "  ",
	vi_mode_icon = " ",
	position_icon = " ",
}

-- Initialize the components table
local components = {
	active = {},
	inactive = {},
}

-- these are the three sections: left, mid, right
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})

table.insert(components.active[1], {
	provider = icon_styles.main_icon,

	hl = {
		fg = colors.bg_dark,
		bg = colors.blue,
	},

	right_sep = {
		str = icon_styles.right,
		hl = {
			fg = colors.blue,
			bg = colors.fg_gutter,
		},
	},
})

table.insert(components.active[1], {
	provider = icon_styles.right,
	hl = {
		fg = colors.fg_gutter,
		bg = colors.bg_highlight,
	},
})

table.insert(components.active[1], {
	provider = function()
		local filename = vim.fn.expand("%:t")
		local extension = vim.fn.expand("%:e")
		local icon = require("nvim-web-devicons").get_icon(filename, extension)
		if icon == nil then
			icon = "  "
			return icon
		end
		return " " .. icon .. " " .. filename .. " "
	end,
	hl = {
		fg = colors.fg,
		bg = colors.bg_highlight,
	},

	right_sep = {
		str = icon_styles.right,
		hl = {
			fg = colors.bg_highlight,
			bg = colors.fg_gutter,
		},
	},
})

table.insert(components.active[1], {
	provider = icon_styles.right,
	hl = {
		fg = colors.fg_gutter,
		bg = colors.bg_highlight,
	},
})

table.insert(components.active[1], {
	provider = function()
		local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
		return "  " .. dir_name .. " "
	end,

	hl = {
		fg = colors.dark3,
		bg = colors.bg,
	},
	right_sep = {
		str = icon_styles.right,
		hl = {
			fg = colors.bg,
			bg = colors.fg_gutter,
		},
	},
})

table.insert(components.active[1], {
	provider = icon_styles.right,
	hl = {
		fg = colors.fg_gutter,
		bg = colors.bg_dark,
	},
})

table.insert(components.active[1], {
	provider = "git_diff_added",
	hl = {
		fg = colors.green1,
		bg = colors.bg_dark,
	},
	icon = "  ",
})

-- diffModfified
table.insert(components.active[1], {
	provider = "git_diff_changed",
	hl = {
		fg = colors.blue1,
		bg = colors.bg_dark,
	},
	icon = "  ",
})

-- diffRemove
table.insert(components.active[1], {
	provider = "git_diff_removed",
	hl = {
		fg = colors.red1,
		bg = colors.bg_dark,
	},
	icon = "  ",
})

table.insert(components.active[1], {
	provider = "diagnostic_errors",
	enabled = function()
		return lsp.diagnostics_exist("Error")
	end,
	hl = { fg = colors.red },
	icon = "  ",
})

table.insert(components.active[1], {
	provider = "diagnostic_warnings",
	enabled = function()
		return lsp.diagnostics_exist("Warning")
	end,
	hl = { fg = colors.yellow },
	icon = "  ",
})

table.insert(components.active[1], {
	provider = "diagnostic_hints",
	enabled = function()
		return lsp.diagnostics_exist("Hint")
	end,
	hl = { fg = colors.fg_dark },
	icon = "  ",
})

table.insert(components.active[1], {
	provider = "diagnostic_info",
	enabled = function()
		return lsp.diagnostics_exist("Information")
	end,
	hl = { fg = colors.green },
	icon = "  ",
})

table.insert(components.active[2], {
	provider = function()
		local Lsp = vim.lsp.util.get_progress_messages()[1]
		if Lsp then
			local msg = Lsp.message or ""
			local percentage = Lsp.percentage or 0
			local title = Lsp.title or ""
			local spinners = {
				"",
				"",
				"",
			}

			local success_icon = {
				"",
				"",
				"",
			}

			local ms = vim.loop.hrtime() / 1000000
			local frame = math.floor(ms / 120) % #spinners

			if percentage >= 70 then
				return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
			else
				return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
			end
		end
		return ""
	end,
	hl = { fg = colors.green },
})

table.insert(components.active[3], {
	provider = function()
		if next(vim.lsp.buf_get_clients()) ~= nil then
			return "   LSP"
		else
			return ""
		end
	end,
	hl = {
		fg = colors.fg_dark,
		bg = colors.bg_dark,
	},
})

table.insert(components.active[3], {
	-- taken from: https://github.com/hoob3rt/lualine.nvim/blob/master/lua/lualine/components/branch.lua
	provider = function()
		local git_branch = ""

		-- first try with gitsigns
		local gs_dict = vim.b.gitsigns_status_dict
		if gs_dict then
			git_branch = (gs_dict.head and #gs_dict.head > 0 and gs_dict.head) or git_branch
		else
			-- path seperator
			local branch_sep = package.config:sub(1, 1)
			-- get file dir so we can search from that dir
			local file_dir = vim.fn.expand("%:p:h") .. ";"
			-- find .git/ folder genaral case
			local git_dir = vim.fn.finddir(".git", file_dir)
			-- find .git file in case of submodules or any other case git dir is in
			-- any other place than .git/
			local git_file = vim.fn.findfile(".git", file_dir)
			-- for some weird reason findfile gives relative path so expand it to fullpath
			if #git_file > 0 then
				git_file = vim.fn.fnamemodify(git_file, ":p")
			end
			if #git_file > #git_dir then
				-- separate git-dir or submodule is used
				local file = io.open(git_file)
				git_dir = file:read()
				git_dir = git_dir:match("gitdir: (.+)$")
				file:close()
				-- submodule / relative file path
				if git_dir:sub(1, 1) ~= branch_sep and not git_dir:match("^%a:.*$") then
					git_dir = git_file:match("(.*).git") .. git_dir
				end
			end

			if #git_dir > 0 then
				local head_file = git_dir .. branch_sep .. "HEAD"
				local f_head = io.open(head_file)
				if f_head then
					local HEAD = f_head:read()
					f_head:close()
					local branch = HEAD:match("ref: refs/heads/(.+)$")
					if branch then
						git_branch = branch
					else
						git_branch = HEAD:sub(1, 6)
					end
				end
			end
		end
		return (git_branch ~= "" and "  " .. git_branch) or git_branch
	end,
	hl = {
		fg = colors.fg_dark,
		bg = colors.bg_dark,
	},
})

table.insert(components.active[3], {
	provider = " " .. icon_styles.left,
	hl = {
		fg = colors.fg_gutter,
		bg = colors.bg_dark,
	},
})

local mode_colors = {
	["n"] = { "NORMAL", colors.red },
	["no"] = { "N-PENDING", colors.red },
	["i"] = { "INSERT", colors.purple },
	["ic"] = { "INSERT", colors.purple },
	["t"] = { "TERMINAL", colors.green },
	["v"] = { "VISUAL", colors.cyan },
	["V"] = { "V-LINE", colors.cyan },
	[""] = { "V-BLOCK", colors.cyan },
	["R"] = { "REPLACE", colors.orange },
	["Rv"] = { "V-REPLACE", colors.orange },
	["s"] = { "SELECT", colors.blue },
	["S"] = { "S-LINE", colors.blue },
	[""] = { "S-BLOCK", colors.blue },
	["c"] = { "COMMAND", colors.magenta2 },
	["cv"] = { "COMMAND", colors.magenta2 },
	["ce"] = { "COMMAND", colors.magenta2 },
	["r"] = { "PROMPT", colors.teal },
	["rm"] = { "MORE", colors.teal },
	["r?"] = { "CONFIRM", colors.teal },
	["!"] = { "SHELL", colors.green },
}

local chad_mode_hl = function()
	return {
		fg = mode_colors[vim.fn.mode()][2],
		bg = colors.bg_highlight,
	}
end

table.insert(components.active[3], {
	provider = icon_styles.left,
	hl = function()
		return {
			fg = mode_colors[vim.fn.mode()][2],
			bg = colors.fg_gutter,
		}
	end,
})

table.insert(components.active[3], {
	provider = icon_styles.vi_mode_icon,
	hl = function()
		return {
			fg = colors.bg_dark,
			bg = mode_colors[vim.fn.mode()][2],
		}
	end,
})

table.insert(components.active[3], {
	provider = function()
		return " " .. mode_colors[vim.fn.mode()][1] .. " "
	end,
	hl = chad_mode_hl,
})

table.insert(components.active[3], {
	provider = icon_styles.left,
	hl = {
		fg = colors.fg_gutter,
		bg = colors.bg_highlight,
	},
})

table.insert(components.active[3], {
	provider = icon_styles.left,
	hl = {
		fg = colors.green,
		bg = colors.fg_gutter,
	},
})

table.insert(components.active[3], {
	provider = icon_styles.position_icon,
	hl = {
		fg = colors.bg_dark,
		bg = colors.green,
	},
})

table.insert(components.active[3], {
	provider = function()
		local current_line = vim.fn.line(".")
		local total_line = vim.fn.line("$")

		if current_line == 1 then
			return " Top "
		elseif current_line == vim.fn.line("$") then
			return " Bot "
		end
		local result, _ = math.modf((current_line / total_line) * 100)
		return " " .. result .. "%% "
	end,

	hl = {
		fg = colors.green,
		bg = colors.bg_highlight,
	},
})

require("feline").setup({
	colors = {
		bg = colors.bg_dark,
		fg = colors.fg,
	},
	components = components,
})
