return {
  "sahilsehwag/macrobank.nvim",
  config = function()
    require("macrobank").setup({
      -- Use larger editor window
      window = {
        width = 0.8,
        height = 0.8,
      },

      -- Custom project store paths
      project_store_paths = { ".macros.json", ".config/macros.json" },

      -- Different default registers
      default_select_register = "x",
      default_play_register = "y",

      -- Disable nerd font icons
      nerd_icons = false,

      -- Override editor buffer mappings (optional)
      live_editor_mappings = {
        save = "<leader>s", -- change save key from <C-s> to <leader>s
        delete = false, -- disable delete key entirely
        play = "<Space>", -- change play key from <CR> to <Space>
      },
      bank_editor_mappings = {
        search = "/", -- change search key from g/ back to /
        history = false, -- disable history feature
        load = "<leader>l", -- change load key from @ to <leader>l
      },
    })
  end,
}
