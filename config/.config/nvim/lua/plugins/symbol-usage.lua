return {
  "Wansmer/symbol-usage.nvim",
  event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = function(o)
    require("symbol-usage").setup({
      vt_position = "end_of_line", -- "eol" | "
    })
  end,
}
