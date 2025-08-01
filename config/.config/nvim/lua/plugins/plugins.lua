return {
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()

      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>") .. "<CR>"
      end, { expr = true, noremap = true, silent = true })
    end,
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = {},
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      -- recommended mappings
      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
      vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
      vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
      vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
      vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
      -- moving between splits
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
      vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
      -- swapping buffers between windows
      vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
      vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
      vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
      vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.disable = { "html", "htmldjango" }
    end,
  },
}
