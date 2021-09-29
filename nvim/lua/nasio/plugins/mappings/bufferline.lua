-- These commands will navigate through buffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
vim.api.nvim_set_keymap("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<s-tab>", "<cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true })
-- Remove a buffer
vim.api.nvim_set_keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { noremap = true, silent = true })
