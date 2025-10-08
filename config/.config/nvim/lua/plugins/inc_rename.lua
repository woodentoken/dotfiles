return {
  {
    "smjonas/inc-rename.nvim",
    lazy = false,
    opts = {
      input_buffer_type = nil,
    },
    config = function(_, opts)
      require("inc_rename").setup(opts)

      -- Keymap for renaming
      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { desc = "Rename", expr = true })
    end,
  },
}
