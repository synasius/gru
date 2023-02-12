local M = {}

M.treesitter = {
  ensure_installed = {
    "lua",
    "c_sharp",
    "python",
    "rust",
    "fish",
  },
}

M.mason = {
  ensure_installed = {
    "lua-language-server",
    "stylua",

    "omnisharp",
  },
}

M.nvchadui = {
  statusline = {
    separator_style = "round",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = false,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
