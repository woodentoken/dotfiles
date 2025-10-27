return {
  "akinsho/bufferline.nvim",
  version = "v3.*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    require("bufferline").setup({
      options = {
        diagnostics = "nvim_lsp",
        numbers = "buffer_id",
        show_buffer_close_icons = false,
        show_buffer_icons = false,
        show_close_icon = false,
        -- style_preset = bufferline.style_preset.minimal,
        indicator = {
          style = "underline",
        },
        offsets = {
          {
            filetype = "Neotree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    })
  end,
}
