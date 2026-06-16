return {
  {
    "smjonas/inc-rename.nvim",
    lazy = false,
    opts = {
      preview_empty_name = true,
      input_buffer_type = nil,
    },
    config = function(_, opts)
      require("inc_rename").setup(opts)

      vim.keymap.set("n", "<leader>rm", ":IncRename ")

      -- Keymap for "edit"renaming
      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { desc = "Rename", expr = true })
    end,
  },
}
