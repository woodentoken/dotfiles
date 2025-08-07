-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find Files (Telescope)" })

-- Toggle line comment with Ctrl+\
vim.keymap.set("n", "<C-\\>", ":Commentary<CR>", { noremap = false, desc = "Toggle comment" })

-- Visual mode: comment selection
vim.keymap.set("v", "<C-\\>", ":Commentary<CR>", { noremap = false, desc = "Toggle comment in visual mode" })

vim.keymap.set("n", ";", ":", { noremap = true, desc = "Quick command mode" })
