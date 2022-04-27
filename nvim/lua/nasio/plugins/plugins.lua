require("packer").startup(function()
	use({
		"wbthomason/packer.nvim",
	})

	-- themes, ux and style
	use({
		"folke/tokyonight.nvim",
	})

	use({
		"feline-nvim/feline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("nasio.plugins.configs.statusline")
		end,
	})

	use({
		"akinsho/bufferline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("nasio.plugins.configs.bufferline")
		end,
		setup = function()
			require("nasio.plugins.mappings.bufferline")
		end,
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("nasio.plugins.configs.blankline")
		end,
	})

	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})

	-- Git utilities
	use({
		"lewis6991/gitsigns.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("nasio.plugins.configs.gitsigns")
		end,
	})

	use({
		"TimUntersberger/neogit",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("nasio.plugins.configs.neogit")
		end,
	})

	-- highlighting
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nasio.plugins.configs.treesitter")
		end,
	})

	-- smooth scroll
	use({
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
		end,
	})

	-- snippet
	use({
		"L3MON4D3/LuaSnip",
		wants = "friendly-snippets",
		config = function()
			require("nasio.plugins.configs.luasnip")
		end,
	})
	use({ "rafamadriz/friendly-snippets" })
	use("Nash0x7E2/awesome-flutter-snippets")

	-- completion
	use({
		"akinsho/flutter-tools.nvim",
		requires = "nvim-lua/plenary.nvim",
	})

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"onsails/lspkind-nvim",
		},
		config = function()
			require("nasio.plugins.configs.cmp")
		end,
	})

	use({
		"neovim/nvim-lspconfig",
		requires = "williamboman/nvim-lsp-installer",
		config = function()
			require("nasio.plugins.configs.lspconfig")
		end,
	})

	-- completion sources
	use({ "saadparwaiz1/cmp_luasnip" })
	use({ "hrsh7th/cmp-nvim-lua" })
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })

	-- other lsp related utilities
	use({
		"kosayoda/nvim-lightbulb",
		config = function()
			vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
		end,
	})

	-- file managing , picker, fuzzy finder
	use({
		"kyazdani42/nvim-tree.lua",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("nasio.plugins.configs.nvimtree")
		end,
		setup = function()
			require("nasio.plugins.mappings.nvimtree")
		end,
	})

	use({ "nvim-telescope/telescope-ui-select.nvim" })
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("nasio.plugins.configs.telescope")
		end,
		setup = function()
			require("nasio.plugins.mappings.telescope")
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({})
		end,
		setup = function()
			require("nasio.plugins.mappings.trouble")
		end,
	})

	use({
		"glepnir/dashboard-nvim",
		config = function()
			require("nasio.plugins.configs.dashboard")
		end,
		setup = function()
			require("nasio.plugins.mappings.dashboard")
		end,
	})

	-- Debugging
	-- use("mfussenegger/nvim-dap")

	-- Trim traling spaces and whitelines at the end of files
	use({
		"cappyzawa/trim.nvim",
		config = function()
			require("trim").setup({
				disable = { "markdown" },
				patterns = {
					[[%s/\s\+$//e]],
					[[%s/\($\n\s*\)\+\%$//]],
					[[%s/\%^\n\+//]],
				},
			})
		end,
	})

	use({
		"terrortylor/nvim-comment",
		config = function()
			require("nasio.plugins.configs.nvimcomment")
		end,
	})
end)

-- Auto compile when there are changes in plugins.lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
