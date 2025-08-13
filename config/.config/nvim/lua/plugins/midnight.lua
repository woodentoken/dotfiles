return {
  {
    "dasupradyumna/midnight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("midnight").setup({
        SnacksPickerGitStatusUntracked = {
          fg = "#cd3f6d", -- :h guifg
          -- bg = BackgroundColor, -- :hC
          -- sp = SpecialColor, -- :h guisp
          -- style = RenderStyle, -- :h attr-list
          -- -- OR
          -- link = TargetHiglightGroup -- :h :hi-link (link to "TargetHiglightGroup")
          -- -- OR
          -- clear = true -- :h :hi-clear (clear "HighlightGroup"; `false` ignores this option)
        },
        -- Options go here
        -- Example: auto_enable = true,
      })
    end,
  },
}
