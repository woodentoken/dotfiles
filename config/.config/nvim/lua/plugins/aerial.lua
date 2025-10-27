return {
  "stevearc/aerial.nvim",
  opts = {
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    backends = { "lsp", "treesitter", "markdown" },
    layout = {
      max_width = 50,
      min_width = 20,
      -- win_opts = { number = true },
      placement = "window",
      resize_to_content = true,
    },
    keymaps = {
      ["H"] = false,
      ["J"] = false,
      ["K"] = false,
      ["L"] = false,
    },
    -- layout = { width = 150 },
    highlight_mode = "split_width",
    autojump = true,
    open_automatic = true,
    show_guides = true,
    show_numbers = true,
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
    },

    -- for some reason this doesnt seem to work...
    icons = {
      Function = "f", -- Functions
      Method = "m", -- Methods
      Class = "", -- Class symbols
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
