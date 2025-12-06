return {
  "stevearc/aerial.nvim",
  opts = {
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    backends = { "lsp", "treesitter", "markdown" },
    layout = {
      -- max_width = 45,
      -- min_width = 15,
      width = 0.2,
      -- win_opts = { number = true },
      placement = "window",
      default_direction = "right",
      resize_to_content = true,
    },
    attach_mode = "global",
    close_automatic_events = { "switch_biffer" },
    highlight_on_jump = 300,
    -- attach_mode = "window",
    keymaps = {
      ["H"] = false,
      ["J"] = false,
      ["K"] = false,
      ["L"] = false,
    },
    -- layout = { width = 150 },
    -- highlight_mode = "split_width",
    autojump = true,
    post_jump_cmd = "normal! zz",
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
