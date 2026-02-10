-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false

vim.diagnostic.enable(true)

vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = false
-- vim.opt.fillchars = { horiz = "H", vert = "L" }

vim.g.lazyvim_picker = "fzf"
vim.g.mapleader = "\\"

vim.g.lazyvim_python_lsp = "ty"
vim.g.lazyvim_python_ruff = "ruff"

-- Enable persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

vim.opt.fileformats = "unix,dos,mac"
