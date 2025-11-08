-- # INSERT mode remaps
vim.keymap.set("i", "<Find>", "<Home>", { noremap = true, desc = "Go to beginning of line" })
vim.keymap.set("i", "<Select>", "<End>", { noremap = true, desc = "Go to end of line" })
vim.keymap.set("i", "<A-r>", ":Fzf oldfiles<CR>", { noremap = true, desc = "Recent files" })

-- # NORMAL mode remaps
vim.keymap.set("n", "<A-,>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Go to previous buffer" })
vim.keymap.set("n", "<A-.>", ":bnext<CR>", { noremap = true, silent = truem, desc = "Go to next buffer" })

vim.keymap.set("n", "<C-\\>", ":Commentary<CR>", { noremap = false, desc = "Toggle comment" })
vim.keymap.set("n", "<Find>", "^", { noremap = true, desc = "Go to beginning of line" })
vim.keymap.set("n", "<Select>", "$", { noremap = true, desc = "Go to end of line" })
-- vim.keymap.set("n", "<leader>bb", "<cmd>Fzf buffers<CR>", { desc = "Display buffers " })
-- vim.keymap.set("n", "<leader>mm", "<cmd>Fzf marks<CR>", { desc = "Display marks " })
vim.keymap.set("n", "<A-r>", ":Fzf oldfiles<CR>", { noremap = true, desc = "Recent files" })
vim.keymap.set("n", "<leader>gg", "<cmd>FzfLua live_grep<CR>", { desc = "Display marks " })
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle left<CR>", { desc = "Toggle Neotree Explorer" })
vim.keymap.set("n", "<leader>b", "<cmd>Neotree toggle buffers right<CR>", { desc = "Toggle Neotree Buffers" })
vim.keymap.set("n", "<leader>aa", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial window" })
vim.keymap.set("n", "<leader>af", "<cmd>lua require('aerial').fzf_lua_picker()<CR>", { desc = "Aerial Fzf picker" })
vim.keymap.set("n", "<leader>ao", "<cmd>AerialOpen!<CR>", { desc = "Open Aerial window" })
vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Go to previous symbol in Aerial" })
vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Go to next symbol in Aerial" })
-- Remove any existing mappings first (optional but safe)
vim.keymap.del("n", "H", { silent = true })
vim.keymap.del("n", "L", { silent = true })

-- Remap Shift-H and Shift-L to navigate windows
vim.keymap.set("n", "H", "<C-w>h", { desc = "Move to left window", silent = true })
vim.keymap.set("n", "L", "<C-w>l", { desc = "Move to right window", silent = true })
vim.keymap.set("n", "K", "<C-w>k", { desc = "Move to upper window", silent = true })
vim.keymap.set("n", "J", "<C-w>j", { desc = "Move to lower window", silent = true })

vim.keymap.set("v", "H", "<C-w>h", { desc = "Move to left window", silent = true })
vim.keymap.set("v", "L", "<C-w>l", { desc = "Move to right window", silent = true })
vim.keymap.set("v", "K", "<C-w>k", { desc = "Move to upper window", silent = true })
vim.keymap.set("v", "J", "<C-w>j", { desc = "Move to lower window", silent = true })

-- # VISUAL mode remaps
vim.keymap.set("v", "<C-\\>", ":Commentary<CR>", { noremap = false, desc = "Toggle comment in visual mode" })
vim.keymap.set("v", "<Find>", "^", { noremap = true, desc = "Go to beginning of line" })
vim.keymap.set("v", "<Select>", "$", { noremap = true, desc = "Go to end of line" })
-- vim.keymap.set("v", "<leader>bb", "<cmd>FzfLua buffers<CR>", { desc = "Display buffers " })
-- vim.keymap.set("v", "<leader>mm", "<cmd>FzfLua marks<CR>", { desc = "Display marks " })
vim.keymap.set("v", "<leader>gg", "<cmd>FzfLua live_grep<CR>", { desc = "Display marks " })
vim.keymap.set("v", "<A-r>", ":Fzf oldfiles<CR>", { noremap = true, desc = "Recent files" })
vim.keymap.set("v", "<leader>e", "<cmd>Neotree toggle left<CR>", { desc = "Toggle Neotree Explorer" })
vim.keymap.set("v", "<leader>b", "<cmd>Neotree toggle buffers right<CR>", { desc = "Toggle Neotree Buffers" })

-- Override <leader>gd to Go to Definition
vim.keymap.set("n", "<leader>gd", function()
  vim.lsp.buf.definition()
end, { desc = "Go to Definition" })

vim.keymap.set("n", "<leader>gr", function()
  vim.lsp.buf.references()
end, { desc = "Go to References" })

vim.keymap.set("n", "<leader>lq", function()
  local win = vim.api.nvim_get_current_win()
  vim.diagnostic.setqflist()
  vim.cmd("copen")
  vim.api.nvim_set_current_win(win)
end, { noremap = false, silent = true, desc = "Quick lsp fix" })

-- vim.keymap.set("n", "<leader>nn", "<cmd>lua Snacks.notifier.show_history()<CR>", { desc = "Show notification history" })

-- vim.api.nvim_set_keymap("i", "<F2>", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename<cr>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("v", "<leader>rn", "<cmd>lua vim.lsp.buf.rename<cr>", { noremap = true, silent = true })

-- Normal mode
-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { silent = true })

-- -- Visual mode (if you want to rename selection)
-- vim.keymap.set("v", "<leader>rn", vim.lsp.buf.rename, { silent = true })
