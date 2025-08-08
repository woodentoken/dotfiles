return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  -- or                              , branch = '0.1.x',
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-\\>"] = require("telescope.actions").select_vertical,
            ["<C-->"] = require("telescope.actions").select_vertical,
          },
          n = {
            ["<C-\\>"] = require("telescope.actions").select_horizontal,
            ["<C-->"] = require("telescope.actions").select_horizontal,
          },
        },
      },
    })
    require("telescope").load_extension("fzf")
  end,
}
