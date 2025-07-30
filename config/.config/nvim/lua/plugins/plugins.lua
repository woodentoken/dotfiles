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
      explorer = {
        -- your explorer configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      picker = {
        sources = {
          explorer = {
            -- your explorer picker configuration comes here
            -- or leave it empty to use the default settings
          },
        },
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
  },
}
