return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      model = "gpt-4.1", -- AI model to use
      temperature = 0.1, -- Lower = focused, higher = creative
      window = {
        border = "rounded",
        width = 0.5, -- 50% of the editor width
      },
      headers = {
        user = ">>> CALL: ",
        assistant = "<<< RESPONSE: ",
        tool = "^^^ TOOL: ",
      },
      separator = "━━",
      show_folds = false, -- Disable folding for cleaner look
      prompt_prefix = "🤖 Copilot> ", -- Custom prompt prefix
      auto_insert_mode = true, -- Enter insert mode when opening
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      vim.keymap.set({ "n" }, "<leader>CC", ":CopilotChatToggle<CR>", { desc = "toggle CopilotChat" })
      vim.keymap.set({ "n" }, "<leader>Cr", ":CopilotChat #buffer Review<CR>", { desc = "code review" })
      vim.keymap.set({ "n" }, "<leader>Cf", ":CopilotChat #buffer Fix<CR>", { desc = "code fix" })
      vim.keymap.set({ "v" }, "<leader>Ce", ":CopilotChatExplain<CR>", { desc = "explain selected code" })
      vim.keymap.set({ "v" }, "<leader>Cd", ":CopilotChatDocs<CR>", { desc = "document selected code" })
    end,
  },
}
