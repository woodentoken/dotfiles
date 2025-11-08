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
      placement = "edge",
      default_direction = "prefer_right",
      resize_to_content = true,
    },
    attach_mode = "window",
    keymaps = {
      ["H"] = false,
      ["J"] = false,
      ["K"] = false,
      ["L"] = false,
    },
    -- layout = { width = 150 },
    -- highlight_mode = "split_width",
    autojump = true,
    open_automatic = false,
    show_guides = true,
    show_numbers = true,
    filter_kind = {
      "Class",
      "Constant",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Struct",
    },
    icons = {
      Class = "≡", -- Class symbols
      Constant = "•", -- Constants
      Enum = "∑", -- Enums
      Event = "†", -- Events
      Field = "›", -- Fields / properties
      Function = "ƒ", -- Functions
      Interface = "↕", -- Interfaces
      Method = "-", -- Methods
      Property = "▪", -- Properties
      Struct = "⧋", -- Structs
      TypeParameter = "T", -- Type parameters / generics
      Variable = "𝓍", -- Variables
    },
  },
}
