local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local check_back_space = function()
	local col = vim.fn.col(".") - 1
	if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
		return true
	else
		return false
	end
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind
			-- set a name for each source
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				path = "[Path]",
			})[entry.source.name]

			return vim_item
		end,
	},
	-- You can set mappings if you want
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(t("<C-n>"), "n")
			elseif luasnip.expand_or_jumpable() then
				vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
			elseif check_back_space() then
				vim.fn.feedkeys(t("<tab>"), "n")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(t("<C-p>"), "n")
			elseif luasnip.jumpable(-1) then
				vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},

	-- You should specify your *installed* sources.
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "path" },
	},
})
