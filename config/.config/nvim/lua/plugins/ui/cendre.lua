return {
  "Aejkatappaja/cendre",
  lazy = true, -- not the active colorscheme; loaded by `:colorscheme`
  priority = 1000,
  config = function()
    require("cendre").setup({
      background = "hard",     -- "hard" | "medium" | "soft"
      italic_virtual_text = false,
    })
  end,
}
