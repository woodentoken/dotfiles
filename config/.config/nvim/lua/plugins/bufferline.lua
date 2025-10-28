return {
  "akinsho/bufferline.nvim",
  version = "v4.9.1",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    require("bufferline").setup({
      options = {
        diagnostics = "nvim_lsp",
        numbers = "ordinal",
        show_buffer_close_icons = false,
        show_buffer_icons = false,
        show_close_icon = false,
        -- style_preset = require("bufferline").style_preset.minimal,
        -- indicator = { style = "underline" },
        -- offsets = {
        --   {
        --     filetype = "neo-tree",
        --     text = "Neotree",
        --     highlight = "Directory",
        --     text_align = "center",
        --   },
        -- },
      },
    })
  end,
}
