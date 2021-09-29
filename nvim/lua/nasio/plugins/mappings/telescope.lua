-- Mappings
local opt = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", opt)
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>", opt)
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>", opt)
vim.api.nvim_set_keymap("n", "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles()<CR>", opt)
vim.api.nvim_set_keymap("n", "<leader>fw", "<cmd>lua require('telescope.builtin').live_grep()<CR>", opt)
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').grep_string()<CR>", opt)
vim.api.nvim_set_keymap("n", "<leader>fp", "<cmd>lua require('telescope.builtin').builtin()<CR>", opt)
vim.api.nvim_set_keymap("n", "<leader>bm", "<cmd>lua require('telescope.builtin').marks()<CR>", opt)
