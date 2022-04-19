-- Leader is comma
vim.g.mapleader = " "

-- Set the colorscheme
vim.opt.termguicolors = true
vim.cmd("colorscheme tokyonight")

-- Indentation options
local indent = 2
vim.opt.tabstop = indent
vim.opt.shiftwidth = indent
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.clipboard = { "unnamedplus", "unnamed" }

-- Allow modified buffers in background
vim.opt.hidden = true

-- Show trailing spaces and tabs
vim.opt.list = true
vim.opt.listchars = { trail = "·", tab = "»·" }

-- Enable mouse support on all modes
vim.opt.mouse = "a"

-- Folding
vim.opt.foldenable = true
vim.opt.foldlevelstart = 10
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- use treesitter for folding

-- numbering
vim.opt.number = true

vim.opt.updatetime = 500

-- global status line
vim.opt.laststatus = 3
