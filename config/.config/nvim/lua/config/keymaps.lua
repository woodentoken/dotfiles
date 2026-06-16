local diagnostics = require("custom.diagnostics")

-- ============================================================
-- Helper functions
-- ============================================================
local claude_winid = nil

local function toggle_claude()
  if claude_winid and vim.api.nvim_win_is_valid(claude_winid) then
    vim.api.nvim_win_close(claude_winid, true)
    claude_winid = nil
    return
  end

  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file ~= "" then
    local cc = require("claude-code")
    local original_cmd = cc.config.command
    cc.config.command = original_cmd
      .. " --append-system-prompt "
      .. vim.fn.shellescape("The user is currently editing: " .. current_file)
    vim.cmd("ClaudeCode")
    cc.config.command = original_cmd
  else
    vim.cmd("ClaudeCode")
  end

  claude_winid = vim.api.nvim_get_current_win()
end

-- ============================================================
-- INSERT mode
-- ============================================================
vim.keymap.set("i", "<Find>", "<Home>", { noremap = true, desc = "Go to beginning of line" })
vim.keymap.set("i", "<Select>", "<End>", { noremap = true, desc = "Go to end of line" })

-- ============================================================
-- NORMAL + VISUAL mode (shared)
-- ============================================================

-- Line navigation
vim.keymap.set({ "n", "v" }, "<Find>", "^", { noremap = true, desc = "Go to beginning of line" })
vim.keymap.set({ "n", "v" }, "<Select>", "$", { noremap = true, desc = "Go to end of line" })
vim.keymap.set({ "n", "v" }, "alt+q", "^", { noremap = true, desc = "Go to beginning of line" })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

-- Comments
vim.keymap.set({ "n", "v" }, "<C-\\>", ":Commentary<CR>", { noremap = false, desc = "Toggle comment" })

-- FZF
vim.keymap.set({ "n", "v" }, "<leader>bb", "<cmd>FzfLua buffers<CR>", { desc = "Display buffers" })
vim.keymap.set({ "n", "v" }, "<leader>mm", "<cmd>FzfLua marks<CR>", { desc = "Display marks" })
vim.keymap.set({ "n", "v" }, "<leader>gg", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep" })
vim.keymap.set({ "n", "v" }, "<leader>oo", "<cmd>FzfLua oldfiles<CR>", { noremap = true, desc = "Recent files" })

-- Neotree
vim.keymap.set({ "n", "v" }, "<leader>e", "<cmd>Neotree toggle left<CR>", { desc = "Toggle Neotree Explorer" })
vim.keymap.set({ "n", "v" }, "<leader>b", "<cmd>Neotree toggle buffers right<CR>", { desc = "Toggle Neotree Buffers" })

-- Aerial
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>AerialToggle<CR>", { desc = "Toggle Aerial window" })
vim.keymap.set(
  { "n", "v" },
  "<leader>af",
  "<cmd>lua require('aerial').fzf_lua_picker()<CR>",
  { desc = "Aerial Fzf picker" }
)
vim.keymap.set({ "n", "v" }, "<leader>ao", "<cmd>AerialOpen<CR>", { desc = "Open Aerial window" })
vim.keymap.set({ "n", "v" }, "<leader>ax", "<cmd>AerialCloseAll<CR>", { desc = "Close all Aerial windows" })

-- ============================================================
-- NORMAL mode
-- ============================================================

-- allows using Alt + hjkl to navigate between windows without leaving the home row
vim.keymap.set("n", "A-l", "<cmd>windcmd l<CR>", { noremap = true, silent = true, desc = "Move to right window" })
vim.keymap.set("n", "A-h", "<cmd>windcmd h<CR>", { noremap = true, silent = true, desc = "Move to left window" })
vim.keymap.set("n", "A-j", "<cmd>windcmd j<CR>", { noremap = true, silent = true, desc = "Move to down window" })
vim.keymap.set("n", "A-k", "<cmd>windcmd k<CR>", { noremap = true, silent = true, desc = "Move to up window" })

-- Clipboard
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })

-- Buffer navigation
vim.keymap.set("n", "<A-,>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Go to previous buffer" })
vim.keymap.set("n", "<A-.>", ":bnext<CR>", { noremap = true, silent = true, desc = "Go to next buffer" })
vim.keymap.set("n", "<A-q>", ":bdelete<CR>", { noremap = true, silent = true, desc = "Delete current buffer" })

-- Aerial
vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Go to previous symbol in Aerial" })
vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Go to next symbol in Aerial" })
vim.keymap.set("n", "<leader>a", function()
  require("aerial").focus()
end, { desc = "Focus aerial window" })

-- Claude
vim.keymap.set("n", "<leader>cc", toggle_claude, { desc = "Toggle Claude" })
vim.keymap.set("n", "<leader>co", "<cmd>ClaudeCodeContinue<CR>", { desc = "Continue last Claude session" })
vim.keymap.set("n", "<leader>cr", "<cmd>ClaudeCodeResume<CR>", { desc = "Resume Claude session" })

-- Diagnostics
vim.keymap.set("n", "<leader>ud", diagnostics.toggle, { desc = "Toggle diagnostics" })
vim.keymap.set("n", "<leader>dv", diagnostics.toggle_virtual_text, { desc = "Toggle virtual text" })

-- LSP
vim.keymap.set("n", "<leader>cd", function()
  vim.lsp.buf.definition()
end, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>cu", function()
  vim.lsp.buf.references()
end, { desc = "Go to References" })
vim.keymap.set("n", "<leader>ci", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" } },
    apply = true,
  })
end, { desc = "LSP sort imports" })

-- Ruff
vim.keymap.set("n", "<leader>do", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeimports" } },
    apply = true,
  })
end, { desc = "Ruff: organize imports" })
vim.keymap.set("n", "<leader>df", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.fixAll.ruff" } },
    apply = true,
  })
end, { desc = "Ruff: fix all auto-fixable issues" })

-- Misc
vim.keymap.set("c", "w!!", "SudaWrite", { desc = "Write file with sudo" })

-- ============================================================
-- TERMINAL mode
-- ============================================================
vim.keymap.set("t", "<leader>cc", toggle_claude, { desc = "Toggle Claude" })

-- ============================================================
-- Cleanup
-- ============================================================
vim.keymap.del("n", "H", { silent = true })
vim.keymap.del("n", "L", { silent = true })

-- ============================================================
-- User commands
-- ============================================================
vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ bufnr = 0, lsp_fallback = true })
end, {})

vim.api.nvim_create_user_command("SortImports", function()
  require("conform").format({
    bufnr = 0,
    formatters = { "ruff_organize_imports" },
  })
end, { desc = "Sort imports" })

vim.api.nvim_create_user_command("W", "w", { nargs = 0 })
