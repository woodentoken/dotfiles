return {
  {
    "smjonas/inc-rename.nvim",
    lazy = false,
    opts = {
      show_message = false, -- Show a message when renaming is successful
      -- input_buffer_type = "snacks", -- Use prompt for input
      post_hook = nil, -- No post-hook function
      pre_hook = nil, -- No pre-hook function
    },
    config = function(_, opts)
      require("inc_rename").setup(opts)

      -- Keymap for renaming
      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true })
    end,
  },
}
