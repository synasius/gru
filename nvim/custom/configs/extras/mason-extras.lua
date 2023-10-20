local setup = function(_, opts)
	local on_attach = require("plugins.configs.lspconfig").on_attach
	local capabilities = require("plugins.configs.lspconfig").capabilities

	local lspconfig = require("lspconfig")

	-- List of servers to install
	local servers = { "omnisharp", "rust_analyzer" }

	require("mason").setup(opts)

	require("mason-lspconfig").setup({
		ensure_installed = servers,
	})

	-- This will setup lsp for servers you listed above
	-- And servers you install through mason UI
	-- So defining servers in the list above is optional
	require("mason-lspconfig").setup_handlers({
		-- Default setup for all servers, unless a custom one is defined below
		function(server_name)
			lspconfig[server_name].setup({
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					-- Add your other things here
					-- Example being format on save or something
				end,
				capabilities = capabilities,
			})
		end,

		["pylsp"] = function()
			lspconfig.pylsp.setup({
				settings = {
					pylsp = {
						plugins = {
							rope_autoimport = { enabled = true },
							rope_completion = { enabled = true },

							autopep8 = { enabled = false },
							flake8 = { enabled = false },
							pycodestyle = { enabled = false },
							pydocstyle = { enabled = false },
							pyflakes = { enabled = false },
							pylint = { enabled = false },
							yapf = { enabled = false },
						},
					},
				},
			})
		end,

		-- custom setup for a server goes after the function above
		-- Example, override rust_analyzer
		-- ["rust_analyzer"] = function ()
		--   require("rust-tools").setup {}
		-- end,

		-- Example: disable auto configuring an LSP
		-- Here, we disable lua_ls so we can use NvChad's default config
		-- ["lua_ls"] = function()
		-- end,
	})
end

---@type NvPluginSpec
local spec = {
	"neovim/nvim-lspconfig",
	-- BufRead is to make sure if you do nvim some_file then this is still going to be loaded
	event = { "VeryLazy", "BufRead" },
	config = function() end, -- Override to make sure load order is correct
	dependencies = {
		{
			"williamboman/mason.nvim",
			config = function(plugin, opts)
				setup(plugin, opts)
			end,
		},
		"williamboman/mason-lspconfig",
		-- format & linting
		{
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("custom.configs.null-ls")
			end,
		},
		-- TODO: Add mason-null-ls? mason-dap?
	},
}

return spec