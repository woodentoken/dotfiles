return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.highlight = opts.highlight or {}
    opts.highlight.enable = true
    opts.highlight.disable = { "html", "htmldjango" }
  end,
}
