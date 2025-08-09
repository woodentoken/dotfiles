-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

vim.diagnostic.enable(false)

vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = false
vim.opt.fillchars = { horiz = "H", vert = "L" }

vim.g.lazyvim_picker = "telescope"
vim.g.mapleader = "\\"

-- remap the capitals...
vim.api.nvim_create_user_command("W", "w", { nargs = 0 })

-- Enable persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
