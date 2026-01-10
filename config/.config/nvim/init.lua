-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.snacks_animate = false

vim.cmd("source ~/.vimrc.base")

-- vim.g.copilot_no_tab_map = true
-- vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
-- vim.keymap.set("i", "<S-Tab>", function()
--   require("copilot.suggestion").accept()
-- end, { desc = "Accept Copilot suggestion" })

-- vim.keymap.set("i", "<C-j>", function()
--   require("copilot.suggestion").next()
-- end, { desc = "Next Copilot suggestion" })

-- vim.keymap.set("i", "<C-k>", function()
--   require("copilot.suggestion").prev()
-- end, { desc = "Previous Copilot suggestion" })

vim.opt.fileformats = { "unix", "dos" }

vim.lsp.config("ruff", {
  init_options = {
    settings = {
      args = { "--fix", "--unsafe-fixes" },
    },
  },
})

vim.lsp.enable("ruff")

-- Remove carriage return characters when pasting
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    if vim.o.paste then
      vim.cmd([[%s/\r//g | silent!]])
    end
  end,
})
