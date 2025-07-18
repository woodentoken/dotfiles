return {
  {
    "smoka7/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()

      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>") .. "<CR>"
      end, { expr = true, noremap = true, silent = true })
    end,
  },
}
