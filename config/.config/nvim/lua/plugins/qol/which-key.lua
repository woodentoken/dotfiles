return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    -- win = {
    --   border = "rounded",
    --   padding = (0,0),
    -- },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
    {
      "<leader>t",
      function()
        require("which-key").show({ mode = "t" })
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>m",
      function()
        require("which-key").show({ mode = "m" })
      end,
      desc = "marks",
    },
    {
      "<leader>o",
      function()
        require("which-key").show({ mode = "o" })
      end,
      desc = "recent",
    },
  },
}
