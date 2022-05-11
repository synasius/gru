-- define custom diagnostics
vim.fn.sign_define("DiagnosticSignWarn", { text = "", numhl = "DiagnosticSignWarn", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define(
	"DiagnosticSignError",
	{ text = "", numhl = "DiagnosticSignError", texthl = "DiagnosticSignError" }
)
vim.fn.sign_define("DiagnosticSignInfo", { text = "", numhl = "DiagnosticSignInfo", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", numhl = "DiagnosticSignHint", texthl = "DiagnosticSignHint" })

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = {
		prefix = "",
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = false, -- update diagnostics insert mode
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "single",
})

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua require[[telescope.builtin]].lsp_definitions{}<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua require[[telescope.builtin]].lsp_references{}<CR>", opts)
	buf_set_keymap("n", "gws", "<cmd>lua require[[telescope.builtin]].lsp_workspace_symbols{}<CR>", opts)
	buf_set_keymap("n", "gwd", "<cmd>lua require[[telescope.builtin]].lsp_workspace_diagnostics{}<CR>", opts)
	buf_set_keymap("n", "gos", "<cmd>lua require[[telescope.builtin]].lsp_document_symbols{}<CR>", opts)
	buf_set_keymap("n", "god", "<cmd>lua require[[telescope.builtin]].lsp_document_diagnostics{}<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<space>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	elseif client.resolved_capabilities.document_range_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end
end

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local black = require("nasio.plugins.configs.efm.black")
local flake8 = require("nasio.plugins.configs.efm.flake8")
local pylint = require("nasio.plugins.configs.efm.pylint")
local isort = require("nasio.plugins.configs.efm.isort")
local mypy = require("nasio.plugins.configs.efm.mypy")
local stylua = require("nasio.plugins.configs.efm.stylua")
local prettier = require("nasio.plugins.configs.efm.prettier")

require("nvim-lsp-installer").setup()
local lspconfig = require("lspconfig")

lspconfig.pylsp.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		pylsp = {
			plugins = {
				pyflakes = { enabled = true },
				pycodestyle = { enabled = false },
				yapf = { enabled = false },
			},
		},
	},
})

lspconfig.efm.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = { documentFormatting = true },
	root_dir = vim.loop.cwd,
	filetypes = { "python", "lua", "javascript", "typescript", "html" },
	settings = {
		rootMarkers = { ".git/", "pyproject.toml" },
		languages = {
			python = { black, flake8, isort, mypy, pylint },
			lua = { stylua },
			javascript = { prettier },
			typescript = { prettier },
			html = { prettier },
		},
	},
})

lspconfig.sumneko_lua.setup({
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			format = { enable = false },
		},
	},
	on_attach = function(client, bufnr)
		-- Disable sumneko_lua builtin formatter because I prefer stylua
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
		on_attach(client, bufnr)
	end,
})

-- Also setup fluttertools
require("flutter-tools").setup({
	debugger = {
		enabled = true,
	},
	fvm = true,
	lsp = {
		on_attach = on_attach,
	},
})
