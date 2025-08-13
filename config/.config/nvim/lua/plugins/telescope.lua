return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  tag = "0.1.8",
  -- or                              , branch = '0.1.x',
  dependencies = { "nvim-lua/plenary.nvim", "debugloop/telescope-undo.nvim" },
  config = function()
    require("telescope").setup({
      extensions = {
        undo = {
          side_by_side = true,
          -- layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.66,
            preview_width = 0.66,
          },
          -- telescope-undo.nvim config, see below
          use_delta = true,
          use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
          vim_diff_opts = {
            ctxlen = vim.o.scrolloff,
          },
          entry_format = "state #$ID, $STAT, $TIME",
          time_format = "",
          saved_only = false,
        },
      },
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

    require("telescope").load_extension("undo")
    require("telescope").load_extension("fzf")
    vim.keymap.set("n", "<C-g>", "<cmd>Telescope live_grep<CR>", { desc = "Find text " })
    -- vim.keymap.set("n", "<C-P>", "<cmd>Telescope find_files<CR>", { desc = "Find files " })
    -- vim.keymap.set("n", "<C-p>", "<cmd>Telescope git_files<CR>", { desc = "Find text " })
    vim.keymap.set("n", "<leader>U", "<cmd>Telescope undo<cr>", { desc = "Undotree" })

    vim.keymap.set("n", "<leader>rr", "<cmd>Telescope registers<CR>", { desc = "Display registers " })
    vim.keymap.set("n", "<leader>B", "<cmd>Telescope buffers<CR>", { desc = "Display buffers " })
  end,
}
