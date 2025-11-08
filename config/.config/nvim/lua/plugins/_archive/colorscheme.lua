return {
  -- add gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    config = true,
    opts = {
      dim_inactive = false,
      transparent_mode = true,
    },
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
  {
    "gruvbox-community/gruvbox", -- or your preferred gruvbox variant
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Replace highlight with underline for current word under cursor
      vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true, bg = "none" })
      vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true, bg = "none" })
      vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true, bg = "none" })
    end,
  },
}
