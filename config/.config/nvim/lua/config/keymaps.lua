-- # INSERT mode remaps
vim.keymap.set("i", "<Find>", "<Home>", { noremap = true, desc = "Go to beginning of line" })
vim.keymap.set("i", "<Select>", "<End>", { noremap = true, desc = "Go to end of line" })
vim.keymap.set("i", "<A-r>", ":Fzf oldfiles<CR>", { noremap = true, desc = "Recent files" })

-- # NORMAL mode remaps
vim.keymap.set("n", "<C-,>", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-.>", ":bnext<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-\\>", ":Commentary<CR>", { noremap = false, desc = "Toggle comment" })
vim.keymap.set("n", "<Find>", "^", { noremap = true, desc = "Go to beginning of line" })
vim.keymap.set("n", "<Select>", "$", { noremap = true, desc = "Go to end of line" })
vim.keymap.set("n", "<leader>bb", "<cmd>Fzf buffers<CR>", { desc = "Display buffers " })
vim.keymap.set("n", "<leader>mm", "<cmd>Fzf marks<CR>", { desc = "Display marks " })
vim.keymap.set("n", "<A-r>", ":Fzf oldfiles<CR>", { noremap = true, desc = "Recent files" })

-- # VISUAL mode remaps
vim.keymap.set("v", "<C-\\>", ":Commentary<CR>", { noremap = false, desc = "Toggle comment in visual mode" })
vim.keymap.set("v", "<Find>", "^", { noremap = true, desc = "Go to beginning of line" })
vim.keymap.set("v", "<Select>", "$", { noremap = true, desc = "Go to end of line" })
vim.keymap.set("v", "<leader>bb", "<cmd>Fzf buffers<CR>", { desc = "Display buffers " })
vim.keymap.set("v", "<leader>mm", "<cmd>Fzf marks<CR>", { desc = "Display marks " })
vim.keymap.set("v", "<A-r>", ":Fzf oldfiles<CR>", { noremap = true, desc = "Recent files" })
