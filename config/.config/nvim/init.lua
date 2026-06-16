-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.snacks_animate = false

vim.keymap.set("n", "57438u", "<Nop>", { silent = true })
vim.keymap.set("i", "57438u", "<Nop>", { silent = true })
vim.keymap.set("v", "57438u", "<Nop>", { silent = true })
vim.keymap.set("c", "57438u", "<Nop>", { silent = true })

vim.keymap.set("n", "57439u", "<Nop>", { silent = true })
vim.keymap.set("i", "57439u", "<Nop>", { silent = true })
vim.keymap.set("v", "57439u", "<Nop>", { silent = true })
vim.keymap.set("c", "57439u", "<Nop>", { silent = true })

vim.keymap.set("n", "57440u", "<Nop>", { silent = true })
vim.keymap.set("i", "57440u", "<Nop>", { silent = true })
vim.keymap.set("v", "57440u", "<Nop>", { silent = true })
vim.keymap.set("c", "57440u", "<Nop>", { silent = true })

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
