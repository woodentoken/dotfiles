-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find Files (Telescope)" })
vim.keymap.set("n", "<C-g>", "<cmd>lua Snacks.dashboard.pick('live_grep')<CR>", { desc = "Live grep" })
