return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  tag = "0.1.8",
  -- or                              , branch = '0.1.x',
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<leader>s"] = require("telescope.actions").select_horizontal,
            ["<leader>v"] = require("telescope.actions").select_vertical,
          },
          n = {
            ["<leader>s"] = require("telescope.actions").select_horizontal,
            ["<leader>v"] = require("telescope.actions").select_vertical,
          },
        },
      },
    })

    require("telescope").load_extension("fzf")
    vim.keymap.set("n", "<C-g>", "<cmd>Telescope live_grep<CR>", { desc = "Find text (Telescope)" })
    vim.keymap.set("n", "<C-P>", "<cmd>Telescope find_files<CR>", { desc = "Find files (Telescope)" })
    vim.keymap.set("n", "<C-p>", "<cmd>Telescope git_files<CR>", { desc = "Find text (Telescope)" })
    vim.keymap.set("n", "<leader>rr", "<cmd>Telescope registers<CR>", { desc = "Display registers (Telescope)" })
    vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<CR>", { desc = "Display buffers (Telescope)" })
  end,
}
