return {
  "stevearc/aerial.nvim",
  opts = {
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    backends = { "lsp", "treesitter", "markdown" },
    layout = { max_width = 50, min_width = 20, default_direction = "top", win_opts = { number = true } },
    highlight_mode = "split_width",
    autojump = true,

    -- for some reason this doesnt seem to work...
    icons = {
      Class = "🏛", -- Class symbols
      Function = "ƒ", -- Functions
      Method = "m", -- Methods
      Variable = "𝓍", -- Variables
      Constant = "π", -- Constants
      Interface = "I", -- Interfaces
      Enum = "∑", -- Enums
      Field = "•", -- Fields / properties
      Property = "▪", -- Properties
      Event = "⚡", -- Events
      Struct = "⧋", -- Structs
      TypeParameter = "T", -- Type parameters / generics
    },
  },
}
